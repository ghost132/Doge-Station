#define CHAN_ADMIN		"182239000063508480"
#define CHAN_BAN		"182513192101085184"
#define CHAN_GENERAL	"176500153492963328"
#define CHAN_INFO		"204025230103019520"

/proc/send_to_discord(channel_id, message)
	if(!config.use_discord_bot)
		return
	if(!channel_id)
		log_debug("send_to_discord() called without channel_id arg.")
		return
	if(!message)
		log_debug("send_to_discord() called without message arg.")
		return

	return POST("https://discordapp.com/api/channels/[channel_id]/messages", {" { \\"content\\" : \\"[message]\\" } "}, "Content-Type: application/json", "Authorization: Bot [config.bot_token]")

/proc/send_to_admin_discord(message)
	send_to_discord(CHAN_ADMIN, message)

/proc/send_to_ban_discord(message)
	send_to_discord(CHAN_BAN, message)

/proc/send_to_main_discord(message)
	send_to_discord(CHAN_GENERAL, message)

/proc/send_to_info_discord(message)
	send_to_discord(CHAN_INFO, message)

#undef CHAN_INFO
#undef CHAN_GENERAL
#undef CHAN_BAN
#undef CHAN_ADMIN