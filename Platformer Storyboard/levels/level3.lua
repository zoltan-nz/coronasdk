-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Jamie Trinder
--www.tandgapps.co.uk

--CoronaSDK version 2012.971 was used for this template.

--The art was sourced from http://biffybeebe.net/graphics/
--Created by Biffy Beebe, you would have to purchase the indie Graphics bundle
--yourself in order to use the graphics in this template in your own game.

--You are not allowed to publish this template to the Appstore as it is. 
--You need to work on it, improve it and replace the graphics. 

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------


--Localise the module. Elimates the need for module package seeall technique.
local M = {}


--This array holds each different screens information. Each screen is 480 pixels wide!
--The movement function in game.lua calls creates each of these screens in turn.
--E.g. blocks/special blocks/obstacles/stars positions...
--You can easily add your own by copying and pasting mine to make the game more interesting!
M = {
	------------------------------------------
	--Screen 1
	------------------------------------------
	{
		--There are 3 different types of block. Select which one you want per block.
		--"breakable" - Are blocks that you can smash
		--"special" - Is a block that a coin will come out of once.
		--"pushable" - A special block you can push around.
		--"plain" - Is a normal block that does nothing.
		blocks = {
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={50,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={100,160},
			},
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={150,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={200,160},
			},
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={250,160},
			},
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {300,276},
			},	
			{	
				widthHeight = {50,16},
				position = {350,276},
			},
			{	
				widthHeight = {50,16},
				position = {400,276},
			},
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
			{
				widthHeight = {50,48},
				position ={250,276},
				allowedMovement = 180, --How far left-right the enemy can walk.
				speed = -2 --How fast they walk. Start walking left.
			},
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
		--You can add more categories here. Just remember to add them into the
		--creationSections function in the game.lua file.
	},

	-------------------------------------------
	--Screen 2
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {80,276},
			},	
			{	
				widthHeight = {50,16},
				position = {130,276},
			},	
			{	
				widthHeight = {50,16},
				position = {320,276},
			},	
			{	
				widthHeight = {50,16},
				position = {370,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
			{
				widthHeight = {50,48},
				position ={30,276},
				allowedMovement = 100, --How far left-right the enemy can walk.
				speed = -2 --How fast they walk. Start walking left.
			},
			{
				widthHeight = {50,48},
				position ={260,276},
				allowedMovement = 100, --How far left-right the enemy can walk.
				speed = -2 --How fast they walk. Start walking left.
			},
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	},

	-------------------------------------------
	--Screen 3
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={50,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={100,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={150,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={100,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={300,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={350,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={350,226},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={225,120},
			},
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
			{	
				widthHeight = {30,42},
				position = {100,166},
			},
			{	
				widthHeight = {30,42},
				position = {350,166},
			},
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {200,276},
			},	
			{	
				widthHeight = {50,16},
				position = {250,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	},


	-------------------------------------------
	--Screen 4
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={50,270},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={50,210},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={50,250},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={100,270},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={100,210},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={100,250},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,176},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,126},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,76},
			},
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
			{	
				widthHeight = {30,42},
				position = {400,21},
			},
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {450,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	},

	-------------------------------------------
	--Screen 5
	--This is going to be the last screen for this
	--level, so all i do is make a tree! (end point)
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {20,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		--To edit its appearance and functions you would have to edit the createSection function in the game.lua file.
		flags = {
			{	
				widthHeight = {50,160},
				position = {320,276}, --BottomCenterReferencePoint
			},	
		},
	},
}


--Set up the screen bounds..
--Limits you going too far left or right. The first one should ALWAYS be 0.
--The second value controls how far right in pixels you can travel. 
--480 = 1 screen, 960 = 2 screens, 1440 = 3 screens, 1920 = 4 screens, 2400 = 5 screens.
M.screenBounds = {0,2400}




--Return it all to the game.
return M

