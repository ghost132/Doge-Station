from .Command import BeatCommand

class commandAdmins(BeatCommand):
	"""Admins count."""

	@classmethod
	async def doCommand(cls, bot, message, params):
		count = bot.ping_server(b"admins")

		if count == None:
			reply = "{0}, sorry! I was unable to ping the server!".format(message.author.mention)
		else:
			if count == 1:
				reply = "{0}, there is **{1}** admin on the server.".format(message.author.mention, count)
			elif count == 0:
				reply = "{0}, there is no admin on the server.".format(message.author.mention)
			else:
				reply = "{0}, there are **{1}** admins on the server.".format(message.author.mention, count)

		await bot.send_message(message.channel, reply)
		return

	@classmethod
	def getName(cls):
		return "Admins"

	@classmethod
	def getDescription(cls):
		return "Get admins count in the server."

	@classmethod
	def getParams(cls):
		return ""

	@classmethod
	def getAuths(cls):
		return []

	@classmethod
	def verifyParams(cls, params):
		return True