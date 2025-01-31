# %builtins output

# from starkware.cairo.common.serialize import serialize_word

# func main{output_ptr : felt*}():
#     serialize_word(6 / 3)
#     serialize_word(7 / 3)
#     serialize_word(3 * 1206167596222043737899107594365023368541035738443865566657697352045290673496)
#     return ()
# end

%builtins output

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word

func array_sum(arr : felt*, size) -> (sum):
    if size == 0:
        return (sum=0)
    end

    # size is not zero.
    let (sum_of_rest) = array_sum(arr=arr + 1, size=size - 1)
    return (sum=[arr] * sum_of_rest)
end

func main{output_ptr : felt*}():
    const ARRAY_SIZE = 5

    # Allocate an array.
    let (ptr) = alloc()

    # Populate some values in the array.
    assert [ptr] = 9
    assert [ptr + 1] = 16
    assert [ptr + 2] = 25
    assert [ptr + 3] = 36
    assert [ptr + 4] = 14

    # Call array_sum to compute the sum of the elements.
    let (sum) = array_sum(arr=ptr, size=ARRAY_SIZE)

    # Write the sum to the program output.
    serialize_word(sum)

    return ()
end


# %builtins output

# from starkware.cairo.common.alloc import alloc
# from starkware.cairo.common.serialize import serialize_word

# func array_prod(arr : felt*, size) -> (prod):
#     if size == 0:
#         return (prod=0)
#     end

#     # size is not zero.
#     let (prod_of_rest) = array_prod(arr=arr + 1, size=size - 1)
#     return (prod=[arr] * prod_of_rest)
# end

# func main{output_ptr : felt*}():
#     const ARRAY_SIZE = 4

#     # Allocate an array.
#     let (ptr) = alloc()

#     # Populate some values in the array.
#     assert [ptr] = 9
#     assert [ptr * 1] = 16
#     assert [ptr * 2] = 25
#     assert [ptr * 3] = 36

#     # Call array_sum to compute the sum of the elements.
#     let (prod) = array_prod(arr=ptr, size=ARRAY_SIZE)

#     # Write the sum to the program output.
#     serialize_word(prod)

#     return ()
# end
