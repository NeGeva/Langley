--Thanks for Tukui
--- ----------------------------------
--> Initiation of Langley
--- ----------------------------------

-->Including System
local addon, engine = ...
engine[1] = {}	--T, constants, variables
engine[2] = {}	--C, config
engine[3] = {}	--F, functions

Langley = engine	--Allow other addons to use Engine

----------------------------------------------------------------------
--This should be at the top of every file inside of the Langley AddOn:	
--local T, C, F = unpack(select(2, ...))

--This is how another addon imports the Langley engine:	
--local T, C, F = unpack(Langley)
----------------------------------------------------------------------

local T, C, F = unpack(select(2, ...))
