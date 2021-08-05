using Thunks
using Test

@testset "reify" begin
    x = thunk(identity)(2)
    y = thunk(identity)(3)
    z = thunk(+)(x, y)
    @test typeof(x) == typeof(y) == typeof(z) == Thunk
    @test z.evaluated == x.evaluated == y.evaluated == false
    @test z.result == x.result == y.result == nothing
    @test reify(z) == 5
    @test z.evaluated == x.evaluated == y.evaluated == true
    @test z.result == 5
    @test x.result == 2
end

@testset "@thunk" begin
    a = b = c = 2
    t = @thunk sum([a,b,c])
    @test typeof(t) == Thunk
    @test reify(t) == 6

    abc = @thunk begin
        a = 1
        b = 2
        c = 4
        sum([a,b,c])
    end
    @test typeof(abc) == Thunk
    @test reify(abc) == 7
end