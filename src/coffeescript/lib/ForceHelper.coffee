require 'createjs'
module.exports = (rotation, speed) ->
  # calculate the factor of the forces
  factor = new createjs.Point(0,0)

  if rotation >= 0 and rotation <= 90
    factor.x = rotation / 90
    factor.y = 1 - factor.x

  else if rotation > 90 and rotation <= 180
    factor.y = (rotation - 90) / 90
    factor.x = 1 - factor.y

  else if rotation < 0 and rotation >= -90
    factor.x = Math.abs(rotation) / 90
    factor.y = 1 - factor.x

  else if rotation < -90 and rotation >= -180
    factor.y = (Math.abs(rotation)-90) / 90
    factor.x = 1 - factor.y

  else
    factor.y = factor.x = 0
  
  # use that factor to calculate the exact forces in each direction
  force = new createjs.Point(0,0)

  if rotation < 0 and rotation >= -90
    force.x = 0 - speed * factor.x;
    force.y = 0 - speed * factor.y;
  
  else if rotation >= 0 and rotation <= 90
    force.x = speed * factor.x;
    force.y = 0 - speed * factor.y;
  
  else if rotation >= 90 and rotation <= 180
    force.x = speed * factor.x;
    force.y = speed * factor.y;
  
  else if rotation <= -90 and rotation >= -180
    force.x = 0- speed * factor.x;
    force.y = speed * factor.y;
  
  else
    # nasty hotfixing.
    force.x = force.y = speed / 2

  # return the force
  return force