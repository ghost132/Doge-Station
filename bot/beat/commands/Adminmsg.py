from .Command import BeatCommand

class commandAdminmsg(BeatCommand):
	"""Send an admin pm to a player in the server."""

	@classmethod
	async def doCommand(cls, bot, message, params):
		if params and params[0] and params[1]:
			msg = ""
			i = 1
			while i < len(params):
				msg += params[i]

				if i < len(params) - 1:
					msg += "+"

				i += 1

			to_send = "adminmsg={0}&key={1}&sender={2}&msg={3}".format(params[0], bot.configValue("server_key"), message.author.name, msg)
			bot.logger.info(to_send)

			server_reply = bot.ping_server(bytes(to_send, "utf-8"))

			if server_reply == None:
				reply = "{0}, sorry! I was unable to ping the server!".format(message.author.mention)
			else:
				reply = "{0}, {1}".format(message.author.mention, server_reply)
		else:
			reply = "{0}, use {1}help to more info!".format(message.author.mention, bot.configValue("prefix"))

		await bot.send_message(message.channel, reply)
		return

	@classmethod
	def getName(cls):
		return "Adminmsg"

	@classmethod
	def getDescription(cls):
		return "Send an admin pm to a player in the server."

	@classmethod
	def getParams(cls):
		return "<player ckey> <message>"

	@classmethod
	def getAuths(cls):
		return ['admins', 'host', 'server head of staff']

	@classmethod
	def verifyParams(cls, params):
		return True