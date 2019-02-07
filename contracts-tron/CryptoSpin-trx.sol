pragma solidity ^0.4.18;

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

// File: contracts-raw/Pausable.sol

contract Pausable is Ownable {
        event Pause ();
        event Unpause ();

        bool public paused        = false;

        modifier whenNotPaused () {
                require(!paused);
                _;
        }

        modifier whenPaused () {
                require (paused);
                _;
        }

        function pause () onlyOwner whenNotPaused public {
                paused  = true;
                emit Pause ();
        }

        function unpause () onlyOwner whenPaused public {
                paused = false;
                emit Unpause ();
        }
}

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

// File: contracts-raw/CryptoSpin-trx.sol

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



contract CryptoSpin is Pausable {
        using SafeMath for uint256;

        uint8 public    version             = 1;

        constructor () public {
        }

        event TronToppedUp (address indexed gamer, uint256 nTrx);
        event TronToppedDown (address indexed gamer, uint256 nTrx);

        mapping (address => uint256) public         nTrxCredited;
        mapping (address => uint256) public         nTrxWithdrawn;

        // Convenience
        function playerInfo (address player) public view returns (uint256, uint256) {

                return (
                    nTrxCredited[player],
                    nTrxWithdrawn[player]
                );
        }

        // Escrew and start game
        function _markCredit (address player, uint256 nTrx) internal {
                // Overflow check (unnecessarily)
                nTrxCredited[player]     = nTrxCredited[player].add (nTrx);
                emit TronToppedUp (player, nTrx);
        }

        function _markWithdraw (address player, uint256 nTrx) internal {
                // Overflow check (unnecessarily)
                nTrxWithdrawn[player]    = nTrxWithdrawn[player].add (nTrx);
                emit TronToppedDown (player, nTrx);
        }

        function buyAndTopup () whenNotPaused public payable {
                // The contract holds the token until refunding
                _markCredit (msg.sender, msg.value);
        }

        function topdownAndCashout (address player, uint256 nTrx) onlyOwner public {
                _markWithdraw (player, nTrx);
                player.transfer (nTrx);
        }

        function transferTokensTo (address target, uint256 nTrx) onlyOwner public {
                target.transfer (nTrx);
        }

        function markCredit (address player, uint256 nTrx) onlyOwner public {
                _markCredit (player, nTrx);
        }

        function () public payable {}

}
