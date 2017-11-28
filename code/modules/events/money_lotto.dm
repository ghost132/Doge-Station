/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(all_money_accounts.len)
		var/datum/money_account/D = pick(all_money_accounts)
		winner_name = D.owner_name
		if(!D.suspended)
			D.money += winner_sum

			var/datum/transaction/T = new()
			T.target_name = "Nyx Daily Grand Slam -Stellar- Lottery"
			T.purpose = "Winner!"
			T.amount = winner_sum
			T.date = current_date_string
			T.time = worldtime2text()
			T.source_terminal = "Biesel TCD Terminal #[rand(111,333)]"
			D.transaction_log.Add(T)

			deposit_success = 1

/datum/event/money_lotto/announce()
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = "Nanotrasen Editor"
	newMsg.is_admin_message = 1

	newMsg.body = "Nyx Daily deseja felicitar <b>[winner_name]</b> para receber a Loteria Nyx Stellar Slam, e receber a soma de [winner_sum] em creditos!"
	if(!deposit_success)
		newMsg.body += "<br>Infelizmente, nao conseguimos verificar os detalhes da conta, por isso nao conseguimos transferir o dinheiro. Envie um cheque contendo a soma de US $ 500 para o escritorio ND 'Stellar Slam' na gateway Nyx contendo detalhes atualizados e seus ganhos serao reenviados dentro do mes."
	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(FC.channel_name == "Nyx Daily")
			FC.messages += newMsg
			break

	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert("Nyx Daily")
