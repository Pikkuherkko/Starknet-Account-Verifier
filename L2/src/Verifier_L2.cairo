%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.messages import send_message_to_l1
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

// storage vars

@storage_var
func l1_to_l2_address_storage(l1_user: felt) -> (l2_user: felt) {
}

@storage_var
func confirmed_storage(l2_user: felt) -> (res: felt) {
}

@storage_var
func verifier_L1_storage() -> (res: felt) {
}

// view functions

// takes L2 address as an input, returns corresponding L1 address
@view
func claimed_l2_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(l1_user: felt) -> (res: felt) {
    let (l2_address) = l1_to_l2_address_storage.read(l1_user);
    return(res=l2_address);
}

@view
func confirmed_l1_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(l2_user: felt) -> (res: felt) {
    let (l1_address) = confirmed_storage.read(l2_user);
    return(res=l1_address);
}

@view
func l1_verifier_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let (address) = verifier_L1_storage.read();
    return(res=address);
}

// constructor

// sets the official L1 contract
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _verifier_L1: felt
) {
    verifier_L1_storage.write(_verifier_L1);
    return ();
}

// external

// user can confirm claim
@external
func confirm_verification{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    l1_address: felt
) {
    let (caller) = get_caller_address();
    let (user) = l1_to_l2_address_storage.read(l1_address);
    with_attr error_message("You are not corresponding L2 address") {
        assert caller = user;
    }
    confirmed_storage.write(caller, l1_address);
    return();
}

// consumes the verification message from L1 and sets a claim for the corresponding L2 address for L1 address
@l1_handler
func handle_l1_verification{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_address: felt, l1_user: felt, l2_user: felt
) {
    let (l1_verifier) = verifier_L1_storage.read();
    with_attr error_message("Message was not sent by the official L1 contract") {
        assert from_address = l1_verifier;
    }
    l1_to_l2_address_storage.write(l1_user, l2_user);
    return();
}