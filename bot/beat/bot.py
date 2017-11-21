from beat.subsystems import *
from beat.commands import *

import discord
import asyncio
import _thread
import struct
import socket
import logging
import sys
import inspect
from threading import Timer

class BotBeat(discord.Client):
	def __init__(self, config_path, **kwargs):
		super(BotBeat, self).__init__(**kwargs)

		# beat.Config instance
		self.config = Config(config_path)
		self.config_thread = None

		# Commands dictionary
		self.commands = {}

		# logging.Logger instance
		# Using discord.py's own logger
		self.logger = logging.getLogger("discord")
		self.logger.setLevel(logging.INFO)

		handler = logging.FileHandler(filename = "beat.log", encoding = "utf-8", mode = "w")
		handler.setFormatter(logging.Formatter("%(asctime)s:%(levelname)s:%(name)s: %(message)s"))

		self.logger.addHandler(handler)

	def setup(self):
		"""Sets up the bot and its various sub-processes."""

		self.logger.info("Bot setup initiated.")

		try:
			self.logger.info("Setting up config.")
			self.config.setup(self, self.logger)
		except RuntimeError as e:
			self.logger.critical("Runtime error during config initialization: {0}".format(e.message))
			raise RuntimeError("Runtime error during config initialization.")

		self.loadCommands()

		self.logger.info("Bot setup completed.")

	def start_beat(self):
		"""Runs the bot."""

		self.logger.info("Bot starting.")

		self.run(self.configValue("token"))

	async def on_message(self, message):
		"""Handles message receipt and command calling."""

		await self.wait_until_ready()

		if message.content.startswith(self.configValue("prefix")) == False or len(message.content) < 1:
			return

		words = message.content.split(" ")

		if words[0][1:].lower() in self.commands:
			command = self.commands[words[0][1:].lower()]

			if self.isAuthorized(command.getAuths(), message.author) == False:
				if message.channel.is_private == True:
					reply = "You are not authorized to use this command."
				else:
					reply = "{0}, you are not authorized to use this command.".format(message.author.mention)
				await self.send_message(message.channel, reply)
				return

			params = []

			if len(words) > 1:
				params = words[1:]

			if command.verifyParams(params) == False:
				await self.send_message(message.channel, "{0}, command failed to execute: not enough, or invalid parameters set. This command requires the following parameters: `{1}`".format(message.author.mention, command.getParams()))
				return

			await command.doCommand(self, message, params)

	def configValue(self, key):
		"""Alias of self.config.getValue()"""

		return self.config.getValue(key)

	def configUserAuths(self, user_id):
		"""Alias of self.config.getUserAuths()"""

		return self.config.getUserAuths(user_id)


	def isAuthorized(self, auth, user):
		"""Check a user's authorization to use a command.

		Keyword arguments:
		auth -- list of strings to check against
		user -- list of user's perms to check

		Returns:
		boolean -- true if is authorized, false otherwise
		"""

		if len(auth) == 0:
			return True

		for role in user.roles:
			for p in auth:
				if role.name.lower() == p:
					return True

		return False

	async def forwardMessage(self, content, channel_str = None, channel_obj = None):
		"""Splits up a message and sends it to all channels in the designated channel group.

		Keyword arguments:
		channel_str -- the name of the channel group we're targeting
		content -- the contents of the message we're creating
		"""

		#if len(self.config.channels[channel_str]) == 0 and channel_obj == None:
		#	return
		if channel_obj != None:
			channel = channel_obj
		else:
			channel = self.get_channel(self.config.getValue('channels')[channel_str])

		await self.send_message(channel, content)
		return

	async def alertMaintainer(self, message):
		await self.forwardMessage("server_info", message)

	def loadCommands(self):

		for name, obj in inspect.getmembers(sys.modules["beat.commands"]):
			if inspect.isclass(obj):
				self.commands[obj.getName().lower()] = obj
				self.logger.info("Added command: {0}".format(obj.getName()))

	def decode_packet(self, packet):
		if packet != "":
			if b"\x00" in packet[0:2] or b"\x83" in packet[0:2]:

				sizebytes = struct.unpack('>H', packet[2:4])  # array size of the type identifier and content # ROB: Big-endian!
				size = sizebytes[0] - 1  # size of the string/floating-point (minus the size of the identifier byte)
				if b'\x2a' in packet[4:5]:  # 4-byte big-endian floating-point
					unpackint = struct.unpack('f', packet[5:9])  # 4 possible bytes: add them up together, unpack them as a floating-point

					return int(unpackint[0])
				elif b'\x06' in packet[4:5]:  # ASCII string
					unpackstr = ''  # result string
					index = 5  # string index
					indexend = index + size

					string = packet[5:indexend].decode("utf-8")
					string = string.replace('\x00', '')

					return string
		return None

	def ping_server(self, question):
		try:

			query = b'\x00\x83'
			query += struct.pack('>H', len(question) + 6)
			query += b'\x00\x00\x00\x00\x00'
			query += question
			query += b'\x00'

			s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			s.connect((self.config.getValue('server_host'), self.config.getValue('server_port')))
			s.settimeout(30)

			if s == None:
				return None

			s.sendall(query)

			data = b''
			while True:
				buf = s.recv(1024)
				data += buf
				szbuf = len(buf)
				if szbuf < 1024:
					break

			s.close()

			response = self.decode_packet(bytes(data))

			if response != None:
				if isinstance(response, int) == True or (response.find('&') + response.find('=') == -2):
					return response
				else:
					parsed_response = {}
					for chunk in response.split('&'):
						chunk = chunk.replace("+", " ")
						dat = chunk.split('=')
						parsed_response[dat[0]] = ''
						if len(dat) == 2:
							parsed_response[dat[0]] = parse.unquote(dat[1])

					return parsed_response
			else:
				return None
		except socket.timeout:
			return None
		except socket.error:
			return None
