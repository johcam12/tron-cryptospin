pragma solidity ^0.4.18;

// File: contracts-raw/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
        function add (uint256 a, uint256 b) internal pure returns (uint256) {
              uint256   c = a + b;
              assert (c >= a);
              return c;
        }

        function sub (uint256 a, uint256 b) internal pure returns (uint256) {
              assert (b <= a);
              return a - b;
        }

        function mul (uint256 a, uint256 b) internal pure returns (uint256) {
                if (a == 0) {
                        return 0;
                }
                uint256 c = a * b;
                assert (c/a == b);
                return c;
        }

        // Solidty automatically throws
        // function div (uint256 a, uint256 b) internal pure returns (uint256) {
        //       // assert(b > 0); // Solidity automatically throws when dividing by 0
        //       uint256   c = a/b;
        //       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        //       return c;
        // }
}

// File: contracts-raw/StandardToken.sol

// ERC20 is ERC20Basic


// ERC20 standard
contract TRC20 {
        // Basic
        function totalSupply () public view returns (uint256);
        function balanceOf (address tokenOwner) public view returns (uint256);
        function transfer (address to, uint256 amount) public returns (bool);
        event Transfer (address indexed from, address indexed to, uint256 amount);

        // Additional
        function allowance (address tokenOwner, address spender) public view returns (uint256);
        function approve (address spender, uint256 amount) public returns (bool);
        function transferFrom (address from, address to, uint256 amount) public returns (bool);
        event Approval (address indexed tokenOwner, address indexed spender, uint256 amount);
}


// BasicToken is ERC20Basic

contract StandardToken is TRC20 {
        using SafeMath for uint256;

        // Basic
        uint256                             _tokenTotal;
        mapping (address => uint256)        _tokenBalances;

        function totalSupply () public view returns (uint256) {
                return _tokenTotal;
        }

        function balanceOf (address tokenOwner) public view returns (uint256) {
                return _tokenBalances[tokenOwner];
        }

        function _transfer (address to, uint256 amount) internal {
                // SafeMath.sub will throw if there is not enough balance.
                // SafeMath.add will throw if overflows
                _tokenBalances[msg.sender]      = _tokenBalances[msg.sender].sub (amount);
                _tokenBalances[to]              = _tokenBalances[to].add (amount);

                emit Transfer (msg.sender, to, amount);
        }

        function transfer (address to, uint256 amount) public returns (bool) {
                require (to != address (0));
                require (amount <= _tokenBalances[msg.sender]);     // should not be necessary, but double checks

                _transfer (to, amount);
                return true;
        }


        // Additional
        mapping (address => mapping (address => uint256)) internal  _tokenAllowance;

        function allowance (address tokenOwner, address spender) public view returns (uint256) {
                return _tokenAllowance[tokenOwner][spender];
        }

        function approve (address spender, uint256 amount) public returns (bool) {
                _tokenAllowance[msg.sender][spender]   = amount;
                emit Approval (msg.sender, spender, amount);
                return true;
        }

        function _transferFrom (address from, address to, uint256 amount) internal {
                // SafeMath.sub will throw if there is not enough balance.
                // SafeMath.add will throw if overflows
                _tokenBalances[from]    = _tokenBalances[from].sub (amount);
                _tokenBalances[to]      = _tokenBalances[to].add (amount);

                emit Transfer (from, to, amount);
        }

        function transferFrom (address from, address to, uint256 amount) public returns (bool) {
                require (to != address (0));
                require (amount <= _tokenBalances[from]);
                require (amount <= _tokenAllowance[from][msg.sender]);

                _transferFrom (from, to, amount);

                _tokenAllowance[from][msg.sender]     = _tokenAllowance[from][msg.sender].sub (amount);
                return true;
        }
}

// File: contracts-raw/Ownable.sol

contract Ownable {
        address public        owner;

        event OwnershipTransferred (address indexed prevOwner, address indexed newOwner);

        constructor () public {
                owner       = msg.sender;
        }

        modifier onlyOwner () {
                require (msg.sender == owner);
                _;
        }

        function transferOwnership (address newOwner) public onlyOwner {
              require (newOwner != address (0));

              emit OwnershipTransferred (owner, newOwner);
              owner     = newOwner;
        }
}

// File: contracts-raw/SpinTrc20-trx.sol

//   ____                  _          ____        _
//  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __
// | |   | '__| | | | '_ \| __/ _ \  \___ \| '_ \| | '_ \
// | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |
//  \____|_|   \__, | .__/ \__\___/  |____/| .__/|_|_| |_|
//             |___/|_|                    |_|

// Crypto Spin - Pixellated Slots with a Crypto Touch
// Copyright 2019 www.cryptospin.co
// In association with www.budapestgame.com

pragma solidity ^0.4.18;




contract SpinTrc20 is StandardToken, Ownable {
        using SafeMath for uint256;

        string public       name                = 'CryptoSpin (tron.cryptospin.co)';
        string public       symbol              = 'SPIN';
        uint8  public       decimals            = 6;

        uint256 public      initialAmount       = 2 * 10**uint(decimals+9);

        constructor () public {
                _tokenTotal                     = initialAmount;
                _tokenBalances[msg.sender]      = initialAmount;
        }


}
