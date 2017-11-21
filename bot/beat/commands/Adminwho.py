from .Command import BeatCommand

class commandAdminwho(BeatCommand):
	"""Admins on the server."""

	@classmethod
	async def doCommand(cls, bot, message, params):
		server_reply = bot.ping_server(b"adminwho")

		if server_reply == None:
			reply = "{0}, sorry! I was unable to ping the server!".format(message.author.mention)
		else:
			reply = "Current admin list:\n\n```\n"
			if isinstance(server_reply, dict):
				for value in server_reply:
					reply += value
					reply += "\n"
				reply += "```\n**{0}** admins on the server.".format(len(server_reply))
			elif len(server_reply) > 1:
				reply += server_reply
				reply += "```\n**1** admin on the server."
			else:
				reply += "```\n**0** admins on the server."

		await bot.send_message(message.channel, reply)
		return

	@classmethod
	def getName(cls):
		return "Adminwho"

	@classmethod
	def getDescription(cls):
		return "Get admins on the server."

	@classmethod
	def getParams(cls):
		return ""

	@classmethod
	def getAuths(cls):
		return []

	@classmethod
	def verifyParams(cls, params):
		return True