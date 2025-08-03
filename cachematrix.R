## Functions that cache the inverse of a matrix

## Create a special "matrix" object that can cache its inverse

makeCacheMatrix <- function(x = matrix()) {
  solve_matrix <- NULL #will store solve()
  
  set <- function(new_value) {
    x <<- new_value
    solve_matrix <<- NULL
  } 
  
  get <- function() x
  setsolve <- function(inverse) solve_matrix <<- inverse
  getsolve <- function() solve_matrix 
  
  message("Your cache matrix is ready!")
  
  list(set = set, get = get, 
       setsolve = setsolve, 
       getsolve = getsolve) 
}


## Compute the inverse of the special "matrix" returned by makeCacheMatrix above

cacheSolve <- function(x, ...) {
  s <- x$getsolve()
  if(!is.null(s)) {
    message("getting cached data for your matrix")
    return(s)
  }
  
  matrix_data <- x$get()
  s = solve(matrix_data, ...)
  x$setsolve(s)
  
  return(s)
}
