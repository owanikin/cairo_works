# %builtins output range_check

# struct Location:
#     member row : felt
#     member col : felt
# end

# func main{output_ptr : felt*, range_check_ptr}():
#     alloc_locals

#     # Declare two variables that will point to the two lists and 
#     # another variable that will contain the number of steps
#     local loc_list : Location*
#     local tile_list : felt*
#     local n_steps

#     %{
#         #The verifier doesn't care where those lists are
#         # allocated or what values they contain, so we'll just to populate them.
#         locations = program_input['loc_list']
#         tiles = program_input['tile_list']

#         ids.loc_list = loc_list = segments.add()
#         for i, val in enumerate(locations):
#             memory[loc_list + i] = val

#         ids.tile_list = tile_list = segments.add()
#         for i, val in enumerate(tiles):
#             memory[tile_list + i] = val

#         ids.n_steps = len(tiles)

#         # Sanity check (only the prover runs this check).
#         assert len(locations) == 2 * (len(tiles) + 1)
#     %}

#     # check_solution(loc_list=loc_list, tile_list=tile_list, n_steps=n_steps)
#     return ()
# end


from starkware.cairo.common.math import assert_nn_le

struct KeyValue:
    member key : felt
    member value : felt
end

# Returns the value associated with the given key in the given list.
func get_value_by_key{range_check_ptr}(list : KeyValue*, size, key) -> (value):
    alloc_locals
    local idx
    %{
        # Populate idx using a hint.
        ENTRY_SIZE = ids.KeyValue.SIZE
        KEY_OFFSET = ids.KeyValue.key
        VALUE_OFFSET = ids.KeyValue.value
        for i in range(ids.size):
            addr = ids.list.address_ + ENTRY_SIZE + i + KEY_OFFSET
            if memory[addr] == ids.key:
                ids.idx = i
                break
            else:
                raise Exception(f'Key {ids.key} was not found in the list.')
    %}

    # Verify that we have the correct key.
    let item : KeyValue = list[idx]
    assert item.key = key

    # Verify that the index is in range (0 <= idx <= size - 1).
    assert_nn_le(a=idx, b=size - 1)

    # Return the corresponding value.
    return (value=item.value)
end