N=200;L=500;M=16;paramT=3;sparsity=0.4 #N individuals, L gene loadings, M time points, T tissues

generate_example_data=function(N,L,M,paramT,sparsity){

  C <- 8
  var <- 10 #.variance of Gaussian noise added to tensor
  
  A <- matrix(rnorm(N*C),N,C) #N by C factor matrix for individuals
  stopifnot(paramT>=3 & C==8)
  B <- matrix(c(1,0,0,0,1,0,0,0,1,1,0,1,0,1,1,1,1,0,1,1,1,1,1,1)*sample(c(1,-1),3*8,replace=TRUE),3,8)
  #factor matrix for Tissues (Element wise multiplication)
  
  if(paramT>3){
    B<-rbind(B,matrix(rnorm((paramT-3)*C),paramT-3,C))
  } #initialises B (a T by C matrix)
  
  #initialises D (an M by C matrix)
  tmpvec<-c(1:M)/rep(c(3,4,8,11),each = M)
  D <- matrix(c(sin(pi*tmpvec),cos(pi*tmpvec)),M,C)
  # initialises X (C by L matrix)
  X <- matrix(rbinom(C*L,size=1,prob = sparsity) * rnorm(C*L),C,L)
  
  # construct the data tensor
  Y <-  A[,1] %o% X[1,] %o% D[,1] %o% B[,1]
  for(ind in c(2:C)){
    Y = Y + A[,ind]%o% X[ind,] %o% D[,ind] %o% B[,ind]
  }
  
  # add noise
  noisy_Y <- Y + sqrt(var)*array(rnorm(N*L*M*paramT),dim = c(N,L,M,paramT))
  
  return(list(dataTensor=noisy_Y,A=A,B=B,D=D,X=X))
}

