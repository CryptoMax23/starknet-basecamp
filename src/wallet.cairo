#[contract]
mod Wallet {
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    struct Storage {
        balance: u128,
        owner: ContractAddress,
        has_owner: u8
    }

    #[constructor]
    fn constructor() {
        let owner = get_caller_address();
        owner::write(owner);
        has_owner::write(0);
        balance::write(0);

        return ();
    }

    #[view]
    fn get_balance() -> u128 {
        balance::read()
    }

    #[view]
    fn get_owner() -> ContractAddress {
        owner::read()
    }

    #[external]
    fn deposit(amount: u128) {
        let current_owner = owner::read();
        let caller = get_caller_address();
        assert(current_owner == caller, 'CALLER_NOT_OWNER');

        let current_balance = balance::read();
        assert(amount >= 0_u128, 'DEPOSIT_MUST_BE_POSITIVE');

        balance::write(current_balance + amount);
    }

    #[external]
    fn withdraw(amount: u128) {
        let current_owner = owner::read();
        let caller = get_caller_address();
        assert(current_owner == caller, 'CALLER_NOT_OWNER');

        let current_balance = balance::read();
        assert(amount >= 0_u128, 'WITHDRAWAL_MUST_BE_POSITIVE');
        assert(current_balance >= amount, 'INSUFFICIENT_FUNDS');
        
        balance::write(current_balance - amount);
    }

    #[external]
    fn set_owner(new_owner: ContractAddress) {
        if (has_owner::read() == 0) {
            owner::write(new_owner);
            has_owner::write(1);
        } else {
            let caller = get_caller_address();
            let current_owner = owner::read();
            assert(current_owner == caller, 'CALLER_NOT_OWNER');
            
            owner::write(new_owner);
            return ();
        }
        assert(1 == 1, 'NOT_PERMITTED');
    }

    #[external]
    fn renounce_ownership(new_owner: ContractAddress) {
        if (has_owner::read() != 0) {
            let caller = get_caller_address();
            let current_owner = owner::read();
            assert(current_owner == caller, 'CALLER_NOT_OWNER');
            
            owner::write(caller);
            has_owner::write(0);
            return ();
        }
        assert(1 == 1, 'NOT_OWNED');
    }
}