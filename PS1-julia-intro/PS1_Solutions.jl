using JLD2, Random, LinearAlgebra, Statistics, CSV, DataFrames, FreqTables, Latexify, LaTeXStrings

######### Question 1 ################

# 1-Initializing variables and practice with basic matrix operations

######################################




#Create the following four matrices of random numbers, setting the seed to ’1234’ .
#Name the matrices and set the dimensions as noted

# create 10x7 distruburted U[-5,10]
Random.seed!(1234)
A = rand(10,7)  .* (10 - (-5)) .- 5

# create 10x7 distruburted random numbers distributed N (−2, 15) [st dev is 15]
Random.seed!(1234)
B = (-2) .+ (randn(10,7) * 15)

# create C 5×7 - the first 5 rows and first 5 columns of A and the last two columns and first 5 rows of B
sub_A = A[1:5,1:5]; sub_B = B[1:5,6:7]
C = hcat(sub_A, sub_B)

### D 10×7 - where Di,j = Ai,j if Ai,j ≤ 0, or 0 otherwise
D = similar(A)

for i in 1:10, j in 1:7
    if A[i,j] <= 0
        D[i,j]=A[i,j]
    else
        D[i,j] = 0
    end  
end

display(D)

# or D = A .* (A .≤ 0)

## Use a built-in Julia function to list the number of elements of A

for i in 1:10, j in 1:7
    println(A[i,j])
end

## Use a series of built-in Julia functions to list the number of unique elements of D

vector_D = D[:]; unique_D = unique(vector_D);
println(unique_D)
print(length(unique_D))

## Using the reshape() function, create a new matrix called E which is the ‘vec’ operator applied to B. Can you find an easier way to accomplish this?

E = reshape(B,:,1)

# easier way
# E  = B[:]

## Create a new array called F which is 3-dimensional and contains A in the first column of the third dimension and B in the second column of the third dimension

F = cat(A, B, dims=3)
# size(F)

## Use the permutedims() function to twist F so that it is now F2×10×7 instead of F10×7×2. Save this new matrix as F.

# permutedims(F, [2, 10, 7])
F = reshape(F,(2,10,7)) 

## Create a matrix G which is equal to B ⊗ C (the Kronecker product of B and C). What happens when you try C ⊗ F ?

G = kron(B,C);

# kron(C, F)  # Doesn't work because they are of different # dimensions

## Save the matrices A, B, C, D, E, F and G as a .jld file named matrixpractice.

matrixpractice = Dict("A"=> A, "B"=> B, "C"=> C, "D"=> D, "E"=> E, "F"=> F, "G"=> G)
@save("matrixpractice.jld", matrixpractice)

## Save only the matrices A, B, C, and D as a .jld file called firstmatrix.

firstmatrix = Dict("A"=> A, "B"=> B, "C"=> C, "D"=> D)
@save("firstmatrix.jld", firstmatrix)

## Export C as a .csv file called Cmatrix. You will first need to transform C into a DataFrame.

typeof(C)
Cmatrix = convert(DataFrame, C)
CSV.write("Cmatirx.csv", Cmatrix)

## Export D as a tab-delimited .dat file called Dmatrix. You will first need to transform D into a DataFrame.

typeof(D)
Dmatrix = convert(DataFrame, D)
@save("Dmatrix.dat", Dmatrix, delim='\t')


################################################

# Wrap a function definition around all of the code for question 1. 
# Call the function q1(). The function should have 0 inputs and should output the arrays 
# A, B, C and D. At the very bottom of your script you should add the code A,B,C,D = q1().

################################################


function q1()
    # 1.a
    Random.seed!(1234);

    A = rand(10,7)  .* (10 - (-5)) .- 5;
    
    B = (-2) .+ (randn(10,7) * 15);
    
    C = zeros(5, 7);
    
    sub_A = A[1:5,1:5]; sub_B = B[1:5,6:7];
    C = hcat(sub_A, sub_B);
    
    D = A .* (A .≤ 0);
    
    D = similar(A);
    for i in 1:10, j in 1:7
        if A[i,j] <= 0
            D[i,j]=A[i,j]
        else
            D[i,j] = 0
        end  
    end

    for i in 1:10, j in 1:7
        println(A[i,j])
    end
    
    
    vector_D = D[:]; unique_D = unique(vector_D);
    print(length(unique_D))

    E = reshape(B,:,1);

    F = cat(A, B, dims=3);
    F = reshape(F,(2,10,7));
    
    G = kron(B,C);
    
    matrixpractice = Dict("A"=> A, "B"=> B, "C"=> C, "D"=> D, "E"=> E, "F"=> F, "G"=> G);
    @save("matrixpractice.jld", matrixpractice)

    Cmatrix = convert(DataFrame, C);
    CSV.write("Cmatirx.csv", Cmatrix)

    Dmatrix = convert(DataFrame, D);
    @save("Dmatrix.dat", Dmatrix, delim='\t')

    return A, B, C, D
end

A,B,C,D = q1()

############## Question 2 ###############

# Practice with loops and comprehensions

#########################################

# Write a loop or use a comprehension that computes the element-by-element product of A and B. 
# Name the new matrix AB. Create a matrix called AB2 that accomplishes this ask without a loop or comprehension.


AB = zeros(size(A)...);

for i = 1:size(A)[1], j = 1:size(A)[2]
    AB[i, j] = A[i, j] * B[i, j];
end


AB2 = A .* B;

# Write a loop that creates a column vector called Cprime which contains only 
#the elements of C that are between -5 and 5 (inclusive). Create a vector called 
# Cprime2 which does this calculation without a loop.


Cprime = Vector{Float64}();        
for item in eachrow(C), i in item
    if   -5 ≤  i ≤ 5
        append!(Cprime,i)
    end
end


Cprime2 = C[-5 .≤ C .≤ 5];


# Using loops or comprehensions, create a 3-dimensional array called X that is of 
# dimen- sionN×K×TwhereN=15,169,K=6,andT=5. Forallt,thecolumnsofX should be (in order)


N = 15_169;
K = 6;
T = 5;
X = zeros(N, K, T);
binord(;n=20, p=0.6) = sum(rand(n) .≤ p);

for t in 1:T
    X[:, 1, t] .= 1;
    X[:, 2, t] = rand(N, 1) .≤ 0.75 * (6 - t) / 5;
    X[:, 3, t] = randn(N, 1) .* 5(t - 1) .+ (15 + t - 1);
    X[:, 4, t] = randn(N, 1) .* (1 / ℯ) .+ π * (6 - t) / 3;
    X[:, 5, t] = [binord() for _ in 1:N];
    X[:, 6, t] = [binord(p=0.5) for _ in 1:N];
end


# Use comprehensions to create a matrix β which is K × T and whose elements evolve across time in the following fashion:

β = zeros(K, T);
β[1, :] = [1 + 0.25(t - 1) for t in 1:T];
β[2, :] = [log(t) for t in 1:T];
β[3, :] = [-sqrt(t) for t in 1:T];
β[4, :] = [exp(t) - exp(t + 1) for t in 1:T];
β[5, :] = [t for t in 1:T];
β[6, :] = [t / 3 for t in 1:T];

# Use comprehensions to create a matrix Y which is N × T defined by Yt = Xt βt + εt , iid

ε = Random.randn(N, T) .* 0.36;
Y = [sum(X[n, :, t] .* β[:, t]) + ε[n, t] for n in 1:N, t in 1:T];


##########################################################

# Wrap a function definition around all of the code for question 2. 
# Call the function q2(). The function should have take as inputs the arrays A, B and C. 
# It should return nothing. At the very bottom of your script you should add the code q2(A,B,C,D). 
#Make sure q2() gets called after q1()!

##########################################################

function q2(A, B, C, D)

    AB = zeros(size(A)...);

    for i = 1:size(A)[1], j = 1:size(A)[2]
        AB[i, j] = A[i, j] * B[i, j];
    end

    AB2 = A .* B;

    Cprime = Vector{Float64}(); 

    for item in eachrow(C), i in item
        if   -5 ≤  i ≤ 5
            append!(Cprime,i)
        end
    end

    Cprime2 = C[-5 .≤ C .≤ 5];

    N = 15_169;
    K = 6;
    T = 5;

    X = zeros(N, K, T);
    Random.seed!(1234)
    binord(;n=20, p=0.6) = sum(rand(n) .≤ p);

    for t in 1:T
        X[:, 1, t] .= 1;
        X[:, 2, t] = rand(N, 1) .≤ 0.75 * (6 - t) / 5;
        X[:, 3, t] = randn(N, 1) .* 5(t - 1) .+ (15 + t - 1);
        X[:, 4, t] = randn(N, 1) .* (1 / ℯ) .+ π * (6 - t) / 3;
        X[:, 5, t] = [binord() for _ in 1:N];
        X[:, 6, t] = [binord(p=0.5) for _ in 1:N];
    end

    β = zeros(K, T);
    β[1, :] = [1 + 0.25(t - 1) for t in 1:T];
    β[2, :] = [log(t) for t in 1:T];
    β[3, :] = [-sqrt(t) for t in 1:T];
    β[4, :] = [exp(t) - exp(t + 1) for t in 1:T];
    β[5, :] = [t for t in 1:T];
    β[6, :] = [t / 3 for t in 1:T];

    ε = randn(N, T) .* 0.36;
    Y = [sum(X[n, :, t] .* β[:, t]) + ε[n, t] for n in 1:N, t in 1:T];

    return nothing
end


q2(A, B, C, D)



############## Question 3 ###############

# Reading in Data and calculating summary statistics

#########################################

# Clear the workspace and import the file nlsw88.csv into Julia as a DataFrame. 

data = CSV.read("/Users/firatmelihyilmaz/fall-2020/ProblemSets/PS1-julia-intro/nlsw88.csv")
describe(data)
@save("nlsw88.jld", data)

#  What percentage of the sample has never been married? What percentage are college graduates?

ptc_never_married = (sum(data["never_married"])/(sum(data["never_married"]) + sum(data["married"]))) * 100;
println("Percentage percentage of the sample has never been married: $ptc_never_married %")

# Use the tabulate command to report what percentage of the sample is in each race category

races = prop(freqtable(data["race"]));
# (prop ∘ freqtable)(data["race"])

# Use the describe() function to create a matrix called summarystats which lists the mean, 
# median, standard deviation, min, max, number of unique elements, and in- terquartile range 
# (75th percentile minus 25th percentile) of the data frame. How many grade observations are missing?

summarystats = describe(data);

# Show the joint distribution of industry and occupation using a cross-tabulation.

joint_table = freqtable(data, :industry, :occupation);


# Wrap a function definition around all of the code for question 3. 
# Call the function q3(). The function should have no inputs and no outputs. 
# At the very bottom of your script you should add the code q3().


function q3()
    data = CSV.read("/Users/firatmelihyilmaz/fall-2020/ProblemSets/PS1-julia-intro/nlsw88.csv");
    @save("nlsw88.jld", data)
    ptc_never_married = (sum(data["never_married"])/(sum(data["never_married"]) + sum(data["married"]))) * 100;
    races = prop(freqtable(data["race"]));
    summarystats = describe(data);    
end


############## Question 4 ###############

# Practice with functions

#########################################

# Load firstmatrix.jld

@load("firstmatrix.jld")

# Write a function called matrixops that takes as inputs the matrices A and B 
# from question (a) of problem 1 and has three outputs: (i) the element-by-element product of the inputs, 
# (ii) the product A′B, and (iii) the sum of all the elements of A + B.

function matrixops(A, B)
    i = A .+ B
    ii = A' * B
    iii = sum(A + B)

    return i, ii, iii   
end

matrixops(A,B);



function matrixops(A, B)
    """
    Takes  matrix A and B as inputs and returns following outputs:

    i = A .+ B
    ii = A' * B
    iii = sum(A + B)
    """
    i = A .+ B
    ii = A' * B
    iii = sum(A + B)

    return i, ii, iii   
end


function matrixops(A, B)
    """
    Takes  matrix A and B as inputs and returns following outputs:

    i = A .+ B
    ii = A' * B
    iii = sum(A + B)
    """
    if size(A) != size(B)
        throw(DimensionMismatch("inputs must have the same size."))
    i = A .+ B
    ii = A' * B
    iii = sum(A + B)

    return i, ii, iii   
end


