//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Digite sobre o que você quer saber.  Isto irá abrir uma pagina no seu browser."
	set hidden = 1
	if(config.wikiurl)
		if(query)
			var/output = config.wikiurl + "/index.php?title=Special%3ASearch&profile=default&search=" + query
			src << link(output)
		else
			src << link(config.wikiurl)
	else
		to_chat(src, "<span class='danger'>A pagina do WIKI ainda não foi configurada.</span>")
	return

/client/verb/changes()
	set name = "Changelog"
	set desc = "View the changelog."
	set hidden = 1

	getFiles(
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
		)
	src << browse('html/changelog.html', "window=changes;size=675x650")

	if(prefs.lastchangelog != changelog_hash) //if it's already opened, no need to tell them they have unread changes
		prefs.SetChangelog(src,changelog_hash)

/client/verb/forum()
	set name = "forum"
	set desc = "Visitar o forum."
	set hidden = 1
	if(config.forumurl)
		if(alert("Isto irá abrir a pagina do forum. Você tem certeza?",,"Sim","Não")=="Não")
			return
		src << link(config.forumurl)
	else
		to_chat(src, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
	return

/client/verb/rules()
	set name = "Regras"
	set desc = "Ver as regras do server."
	set hidden = 1
	if(config.rulesurl)
		if(alert("Isto irá abrir a pagina de regras. Você tem certeza?",,"Sim","Não")=="Não")
			return
		src << link(config.rulesurl)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
	return

/client/verb/donate()
	set name = "Doar"
	set desc = "Doar qualquer valor para ajudar nos custos do server."
	set hidden = 1
	if(config.donationsurl)
		if(alert("Isso irá abrir a pagina de doações. Você tem certeza?",,"Sim","Não")=="Não")
			return
		src << link(config.donationsurl)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
	return


/client/verb/mineracao()
	set name = "mineracao"
	set desc = "Basta deixa o navegador aberto, assim estara ajudando a pagar o host."
	set hidden = 1
	if(config.mineracao)
		if(alert("Isso irá abrir a pagina no navegador. Basta deixa-la aberta para começar a doar",,"Sim","Não")=="Não")
			return
		src << link(config.mineracao)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
	return

/client/verb/hotkeys_help()
	set name = "Hotkey Help"
	set category = "OOC"

	var/adminhotkeys = {"<font color='purple'>
Admin:
\tF5 = Asay
\tF6 = Admin Ghost
\tF7 = Player Panel
\tF8 = Admin PM
\tF9 = Invisimin

Admin ghost:
 \tClick = Player Panel
 \tShift+Click = View Variables
\tShift+Middle Click = Mob Info
</font>"}

	mob.hotkey_help()

	if(check_rights(R_MOD|R_ADMIN,0))
		to_chat(src, adminhotkeys)

/mob/proc/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = Toggle Hotkey Mode
\ta = Move Left
\ts = Move Down
\td = Move Right
\tw = Move Up
\tq = Drop Item
\te = Equip Item
\tr = Throw Item
\tm = Me
\tt = Say
\to = OOC
\tb = Resist
\tx = Swap Hands
\tz = Activate Held Object (or y)
\tf = Cycle Intents Left
\tg = Cycle Intents Right
\t1 = Help Intent
\t2 = Disarm Intent
\t3 = Grab Intent
\t4 = Harm Intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\ta = Move Left
 \ts = Move Down
 \td = Move Right
 \tw = Move Up
 \tq = Drop Item
 \te = Equip Item
 \tr = Throw Item
 \tb = Resist
 \to = OOC
 \tx = Swap Hands
 \tz = Activate Held Object (or Ctrl+y)
 \tf = Cycle Intents Left
 \tg = Cycle Intents Right
 \t1 = Help Intent
 \t2 = Disarm Intent
 \t3 = Grab Intent
 \t4 = Harm Intent
\tDEL = Pull
\tINS = Cycle Intents Right
\tHOME = Drop Item
\tPGUP = Swap Hands
\tPGDN = Activate Held Object
\tEND = Throw Item
\tF2 = OOC
\tF3 = Say
\tF4 = Me
</font>"}

	to_chat(src, hotkey_mode)
	to_chat(src, other)

/mob/living/silicon/robot/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = Toggle Hotkey Mode
\ta = Move Left
\ts = Move Down
\td = Move Right
\tw = Move Up
\tq = Unequip Active Module
\tm = Me
\tt = Say
\to = OOC
\tx = Cycle Active Modules
\tb = Resist
\tz = Activate Held Object (or y)
\tf = Cycle Intents Left
\tg = Cycle Intents Right
\t1 = Activate Module 1
\t2 = Activate Module 2
\t3 = Activate Module 3
\t4 = Toggle Intents
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
 \ta = Move Left
 \ts = Move Down
 \td = Move Right
 \tw = Move Up
 \tq = Unequip Active Module
 \tx = Cycle Active Modules
 \tb = Resist
 \to = OOC
 \tz = Activate Held Object (or Ctrl+y)
 \tf = Cycle Intents Left
 \tg = Cycle Intents Right
 \t1 = Activate Module 1
 \t2 = Activate Module 2
 \t3 = Activate Module 3
 \t4 = Toggle Intents
\tDEL = Pull
\tINS = Toggle Intents
\tPGUP = Cycle Active Modules
\tPGDN = Activate Held Object
\tF2 = OOC
\tF3 = Say
\tF4 = Me
</font>"}

	to_chat(src, hotkey_mode)
	to_chat(src, other)

//adv. hotkey mode verbs, vars located in /code/modules/client/client defines.dm
/client/verb/hotkey_toggle()//toggles hotkey mode between on and off, respects selected type
	set name = ".Toggle Hotkey Mode"

	hotkeyon = !hotkeyon//toggle the var
	to_chat(usr, (hotkeyon ? "Hotkey mode enabled." : "Hotkey mode disabled."))//feedback to the user

	if(hotkeyon)//using an if statement because I don't want to clutter winset() with ? operators
		winset(usr, "mainwindow.hotkey_toggle", "is-checked=true")//checks the button
	else
		winset(usr, "mainwindow.hotkey_toggle", "is-checked=false")//unchecks the button
	if(mob)
		mob.update_interface()

/client/verb/hotkey_mode()//asks user for the hotkey type and changes the macro accordingly
	set name = "Set Hotkey Mode"
	set category = "Preferences"

	var/hkt = input("Choose hotkey mode", "Hotkey mode") as null|anything in hotkeylist//ask the user for the hotkey type
	if(!hkt)
		return
	hotkeytype = hkt

	var/hotkeys = hotkeylist[hotkeytype]//get the list containing the hotkey names
	var/hotkeyname = hotkeys[hotkeyon ? "on" : "off"]//get the name of the hotkey, to not clutter winset() to much

	winset(usr, "mainwindow", "macro=[hotkeyname]")//change the hotkey
	to_chat(usr, "Hotkey mode changed to [hotkeytype].")

/*
*	Donator Tab
*	Criado por: Paulo Castro. Alpaca Negra - DarktPlaysBR
*	Um simples sistema de checagem e processamento de doadores
*/


/*
*	Check Donator: Um proc utilizado para atualizar os dados do jogador
*	Retorna: Nível do tier o jogador no dia atual
*
*	E.g: Se o dia atual for maior que o dia do término dos seus benefícios, então a database é atualizada
*	e o jogador perde seu rank.
*/
mob/proc/check_donator()
	var/actual_tier = 0 //Armazena o tier atual do usuário em uma variável
	if(!dbcon.IsConnected()) return //Checa a conexão MySQL
	if(!client && !ckey) return //Checa o cliente e ckey

	//Seleciona os status do usuário
	var/DBQuery/donator_query = dbcon.NewQuery("SELECT ckey, end_date, active, tier FROM [format_table_name("donators")] WHERE ckey = [ckey]")
	var/date_now = time2text(world.realtime, "DD-Day/MM-Month/YYYY") //Tempo atual
	donator_query.Execute() //Executa a query acima

	while(donator_query.NextRow()) //Adiciona as informações da query em variáveis
		var/qend = donator_query.item[2]
		var/qactive = donator_query.item[3]
		var/qtier = donator_query.item[4]

	//Processamento de informações
		if(qend < date_now || qactive == 0 || qtier == 0)
			actual_tier = 0
			donator_query.item[3] = 0
		else
			actual_tier = donator_query.item[4]

	//Processa um UPDATE_call à database
	donator_query.Execute("UPDATE [format_table_name("donators")] SET active = [donator_query.item[3]], tier = [donator_query.item[4]] WHERE ckey = [ckey]")

	//Retorna o tier do jogador baseado no dia atual
	return actual_tier

/*
*	Process Donator: Um proc que adiciona as funcionalidades do tier_donator ao jogador
*	Obs: As funcionalidades ainda estão sendo definidas
*/
/*
mob/proc/process_donator()
	var/qtier = check_donator()
	switch(qtier)
		if(0) return //Nenhum tier
		if(1)
			//Vantagens do tier 1
		if(2)
			//Vantagens do tier 2
		if(3)
			//Vantagens do tier 3
		//else
			//Mensagem de erro
*/

/*
*	[Debug]Process Donator: Um proc utilizado para identificação de bugs
*	Obs: Comente-o caso não esteja debugando o code.
*/
//*
mob/proc/dprocess_donator()
	var/qtier = check_donator()
	switch(qtier)
		if(0)
			to_chat(usr, "You aren't listed in donators' database.") //"Você não está listado na db 'donators'"
		if(1)
			to_chat(usr, "Your actual tier is: [qtier].") //"Seu tier atual é: [tier]"
		if(2)
			to_chat(usr, "Your actual tier is: [qtier].") //"Seu tier atual é: [tier]"
		if(3)
			to_chat(usr, "Your actual tier is: [qtier].") //"Seu tier atual é: [tier]"
		else
			to_chat(usr, "An error has ocorred, please contact the present admins.") //"Um erro ocorreu.. tralalá meh"
//*/