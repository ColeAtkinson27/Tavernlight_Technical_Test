-- Managing to locate where the spells are actually called from, the Eternal Winter spell was used as a base,
-- as it used the correct ice tornado effect.

-- Despite attempts at searching for a solution, the last two parts of the spell were not completed:
-- 1. The spell's checkerboard pattern should form around the player, rather than the player being on the checkerboard shape.
-- 2. The spell should also create and destroy multiple effects over a period of time. My assumption is that this can be
--    accomplished using the addEvent() function, but due to issues with the function during question 7, this solution was
--    unavailable, and I was unable to find an alternative.

local combat = Combat()

-- The following matrix was created to get the desired shape for the spell effect. Because the effect only creates
-- an ice tornado on every other tile on the diagonal, an extra space on the right side was created to give the correct
-- size of the diamond. One less and the diamond would have ignored the outermost 1's. One more and the diamond would be
-- too large.
AREA_DIAMOND = {
	{0, 0, 0, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 2, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 0, 0, 0}
}

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_DIAMOND))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 5.5) + 25
	local max = (level / 5) + (maglevel * 11) + 50
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end