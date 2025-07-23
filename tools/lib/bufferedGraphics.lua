return {
  --[[
  Given a graphics object,
  this provides a facade which delegates to it on all but the following functions:

  rectangle
  line
  draw
  printf

  These functions get wrapped up with decorators which redirect drawing to a canvas.
  
  --]]
}
