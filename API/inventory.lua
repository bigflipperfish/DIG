--------------------------------------------------------------------------------
-- Filename: inventory
--
-- Description:
-- A group of common functions for turtle's inventory management use
--------------------------------------------------------------------------------

--[[ find an item in turtle's inventory
--------------------------------------------------------------------------------
-- Finds a specified item within the turtle's inventory and selects it
--
-- Arguments:
-- name    - (string) the name of the item that is to be found
-- value   - (number) (optional) the damage value of the item that is to be
--           found
--
-- Returns:
-- False if item could not be found
------------------------------------------------------------------------------]]
function find(name, value)
  if value == nil then
    value = 0
  end
  
  for slot = 1,16 do
    local details = turtle.getItemDetail(slot)
    if details then
      if details.name == name and details.damage == value then
        turtle.select(slot)
        return true
      end
    end
  end
end
