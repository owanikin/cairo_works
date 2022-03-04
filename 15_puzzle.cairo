# # %builtins output range_check

# # from starkware.cairo.common.registers import get_fp_and_pc

# # func main():
# #     alloc_locals

# #     local loc_tuple : (Location, Location, Location, Location, Location) = (
# #         Location(row=0, col=2),
# #         Location(row=1, col=2),
# #         Location(row=1, col=3),
# #         Location(row=2, col=3),
# #         Location(row=3, col=3),
# #     )

# #     local tiles : (felt, felt, felt, felt) = (3, 7, 8, 12)

# #     # Get the value of the frame pointer register (fp) so that we can use the address of loc_tuple.
# #     let (__fp__, _) = get_fp_and_pc()
# #     check_solution(
# #         loc_list = cast(&loc_tuple, Location*),
# #         tile_list = cast(&tiles, felt*),
# #         n_steps = 4)
# #     return ()
# #     # Since the tuple elements are next to each other we can use the address of loc_tuple as a pointer to the 5 locations.
# # end

# # # define a struct that represents a tile location
# # struct Location:
# #     member row : felt
# #     member col : felt
# # end

# # # Function that verifies that a location is valid:
# # func verify_valid_location(loc : Location*):
# #     # Check that row is in the range 0-3.
# #     tempvar row = loc.row
# #     assert row * (row - 1) * (row - 2) * (row - 3) = 0

# #     # Check that col is in the range 0-3.
# #     tempvar col = loc.col
# #     assert col * (col - 1) * (col - 2) * (col - 3) = 0

# #     return ()
# # end

# # # Function that verifies adjacent locations.
# # func verify_adjacent_locations(loc0 : Location*, loc1 : Location*):
# #     alloc_locals
# #     local row_diff = loc0.row - loc1.row
# #     local col_diff = loc0.col - loc1.col

# #     if row_diff == 0:
# #         # The row coordinate is the same. Make sure the difference in col is 1 or -1
# #         assert col_diff * col_diff = 1
# #         return ()
# #     else:
# #         # Verify the difference in row is 1 or -1.
# #         assert row_diff * row_diff = 1
# #         # Verify that the col coordinate is the same.
# #         assert col_diff = 0
# #         return ()
# #     end
# # end

# # # Verify that the location is valid and adjacent to the location.
# # func verify_location_list(loc_list : Location*, n_steps):
# #     # Always verify that the location is valid, even if 
# #     # n_steps is 0. (remember that there is always one more location than steps).
# #     verify_valid_location(loc=loc_list)
    
# #     if n_steps == 0:
# #         return ()
# #     end

# #     verify_adjacent_locations(loc0=loc_list, loc1=loc_list + Location.SIZE)

# #     # Call verify_location_list recursively.
# #     verify_location_list(loc_list=loc_list + Location.SIZE, n_steps=n_steps - 1)
# #     return ()
# # end

# %builtins output range_check
# from starkware.cairo.common.registers import get_fp_and_pc
# from starkware.cairo.common.alloc import alloc

# func check_solution{output_ptr : felt*, range_check_ptr}(
#         loc_list : Location*, tile_list : felt*, n_steps):
#     alloc_locals

#     # Start by verifying that loc_list is valid.
#     verify_location_list(loc_list=loc_list, n_steps=n_steps)

#     # Allocate memory for the dict and the squashed dict.
#     let (local dict_start : DictAccess*) = alloc()
#     let (local squashed_dict : DictAccess*) = alloc()

#     let (dict_end) = build_dict(
#         loc_list=loc_list,
#         tile_list=tile_list,
#         n_steps=n_steps,
#         dict=dict_start)

#     let (dict_end) = finalize_state(dict=dict_end, idx=15)

#     let (squashed_dict_end : DictAccess*) = squash_dict(
#         dict_accesses=dict_start,
#         dict_accesses_end=dict_end,
#         squashed_dict=squashed_dict)

#     # Store range_check_ptr in a local variable to make it
#     # accessible after the call to output_initial_values().
#     local range_check_ptr = range_check_ptr

#     # Verify that the squashed dict has exactly 15 entries.
#     # This will guarantee that all the values in the tile list
#     # are in the range 1-15.
#     assert squashed_dict_end - squashed_dict = 15 *
#         DictAccess.SIZE

#     output_initial_values(squashed_dict=squashed_dict, n=15)

#     # Output the initial location of the empty tile.
#     serialize_word(4 * loc_list.row + loc_list.col)

#     # Output the number of steps.
#     serialize_word(n_steps)

#     return ()
# end

# func main{output_ptr : felt*, range_check_ptr}():
#     alloc_locals

#     local loc_tuple : (Location, Location, Location, Location, location) = (
#         Location(row=0, col=2),
#         Location(row=1, col=2),
#         Location(row=1, col=3),
#         Location(row=2, col=3),
#         Location(row=3, col=3),
#         )
    
#     local tiles : (felt, felt, felt, felt) = (3, 7, 8, 12)
#     # Get the value of the frame pointer register (fp) so that
#     # We can use the address of loc0.
#     let (__fp__, _) = get_fp_and_pc()
#     check_solution(
#         loc_list=cast(&loc_tuple, Location*),
#         tile_list=cast(&tiles, felt*),
#         n_steps=4)
#     return ()
# end


# # func verify_valid_location(loc : Location*):
# #     # Check that row is in the range 0-3.
# #     tempvar row = loc.row
# #     assert row * (row - 1) * (row - 2) * (row - 3) = 0

# #     # Check that row is in the range 0-3.
# #     tempvar col = loc.col
# #     assert col * (col - 1) * (col - 2) * (col - 3) = 0

# #     return ()
# # end

# # func verify_adjacent_locations(
# #         loc0 : Location*, loc1 : Location*):
# #     alloc_locals
# #     local row_diff = loc0.row - loc1.row
# #     local col_diff = loc0.col - loc1.col

# #     if row_diff == 0:
# #         # The row coordinante is the same. Make sure the difference
# #         # in col is 1 or -1.
# #         assert col_diff * col_diff = 1
# #         return ()
# #     else:
# #         # Verify the difference in row is 1 or -1.
# #         assert row_diff * col_diff = 1
# #         # Verify that the col coordinate is the same.
# #         assert col_diff = 0
# #         return ()
# #     end
# # end

# # func verify_location_list(loc_list : Location*, n_steps):
# #     # Always verify that the location is valid, even if
# #     # n_steps = 0 (remember that there is always one more
# #     # location than steps).
# #     verify_valid_location(loc=loc_list)

# #     if n_steps == 0:
# #         return ()
# #     end

# #     verify_adjacent_locations(loc0=loc_list, loc1=loc_list + Location.SIZE)

# #     # Call verify_location_list recursively.
# #     verify_location_list(loc_list=loc_list + Location.SIZE, n_steps=n_steps - 1)

# #     return ()
# # end


func foo() -> (res):
    alloc_locals
    local x = 5 # Note this line
    assert x * x = 25
    return (res=x)
end

func bar() -> (res):
    alloc_locals
    local x
    %{ ids.x = 5 %} # Note this line # The prover is given this hint
    assert x * x = 25
    return (res=x)
end