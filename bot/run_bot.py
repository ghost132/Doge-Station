from beat import BotBeat

bot = BotBeat("config.yml")

print("Bot created. Setting up.")

bot.setup()

print("Setup done.")
print("Running bot.")

bot.start_beat()