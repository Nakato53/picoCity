function MenuScreenNew()



	return {
		datas = {
			position = 1,
			slides =
			{
				{
					titre = "bienvenue",
					lines = {
						"debutons par un petit tutorial",
						"...",
						"",
						"",
						"(->) pour continuer"
					}
				},
				{
					titre = "dans gc-sim ...",
					lines = {
						"vous devez faire grandir",
						"une ville depuis son",
						"commencement ",
						"",
						"depuis quelque cases",
						"jusqu'a une grande ville",
						"(->) pour continuer"
					}
				},
				{
					titre = "pour commencer",
					lines = {
						"vous allez devoir choisir",
						"un monde de depart",
						"",
						"vous pourrez choisir",
						"parmis une multitude",
						"de monde",
						"",
						"(->) pour continuer"
					}
				},
				{
					titre = "bien choisir ...",
					lines = {
						"vous devez pouvoir",
						"nourrir vos vilageois",
						"repondre a leur soif",
						"construire leurs maisons",
						"",
						"choisissez donc bien ",
						"...",
						"",
						"(->) pour continuer"
					}
				},
				{
					titre = "(!) attention (!) ",
					lines = {
						"vos villageois consomment",
						"de l'eau et nourriture ",
						"toute les nuits",
						"",
						"un manque de ressources ",
						"fait partir vos villageois",
						"",
						
						"(->) pour continuer"
					}
				},
				{
					titre = "les ressouces",
					lines = {
						"les fermes ont un temps ",
						"de production de 3 jours",
						"",
						"les scieries et chateau d'eau",
						"delivrent les leurs tout ",
						"les jours",
						"",
						
						"(->) pour continuer"
					}
				},
				{
					titre = "les touches",
					lines = {
						"fleches pour vous deplacer",
						"x pour ouvrir les constructions",
						"x pour valider une construction",
						"c pour annuler",
						"s pour upgrade sur ",
						"    l'hotel de ville",
						"",
						
						" X pour demarrer"
					}
				},

			}
		},
		update = MenuScreenUpdate,
		draw = MenuScreenDraw
	}
end

function MenuScreenUpdate()

	if(btnp(1)) then 
		currentScreen.datas.position+=1
		if currentScreen.datas.position > #currentScreen.datas.slides then
			currentScreen.datas.position = #currentScreen.datas.slides
		end
	end


	if(btnp(5)) then 
		currentScreen = WorldSelectionScreenNew()
	end
	
end

function MenuScreenDraw()
		cls(4)


		rect(0,0,127,127, 13)
		rect(9,28,117,37, 13)
		rectfill(10,28,117,37, 7)

		local infos = currentScreen.datas.slides[currentScreen.datas.position]
		print(infos.titre, 40,30,13)

		for i=1,#infos.lines do
			print(infos.lines[i], 3,50+i*7,7)
		end
		
			
	
end