pragma solidity >=0.4.22 <0.9.0;

pragma experimental ABIEncoderV2;

contract Actor {
    string public id;
    string public name;
    string public actorType;
    string public latitude;
    string public longitude;
    address public owner;

    constructor(
        string memory _id,
        string memory _name,
        string memory _actorType,
        string memory _latitude,
        string memory _longitude
    ) public {
        id = _id;
        name = _name;
        actorType = _actorType;
        latitude = _latitude;
        longitude = _longitude;
        owner = msg.sender;
    }

    event TransactionCreated(address _address);

    function createTransaction(
        Transaction.Product[] memory _productsInput,
        Transaction.Product[] memory _productsOutput,
        Actor _buyer,
        string memory _idTransaction,
        Transaction.TransportType _transport
    ) public {
        require(msg.sender == owner, "Only the actor can create a transaction");

        Transaction newTransaction = new Transaction(
                _idTransaction,
                _buyer,
                this,
                _transport,
                _productsInput,
                _productsOutput
            );
        emit TransactionCreated(address(newTransaction));
    }
}

contract Transaction {
    enum TransportType {Avion, Train, Bateau, Camion, Charette}

    struct Product {
        string productId;
        address addressTransaction;
    }

    struct Products {
        mapping(uint256 => Product) products;
        uint256 size;
    }

    string public idTransaction;
    Actor public buyer;
    Actor public seller;
    uint256 public date;
    TransportType public transport;
    Product[] public productsInput;
    Product[] public productsOutput;
    bool public isFinished;
    bool public isAccepted;

    constructor(
        string memory _idTransaction,
        Actor _buyer,
        Actor _seller,
        TransportType _transport,
        Product[] memory _productsInput,
        Product[] memory _productsOutput
    ) public {
        idTransaction = _idTransaction;
        seller = _seller;
        buyer = _buyer;
        date = block.timestamp;
        transport = _transport;
        for (uint256 index = 0; index < _productsInput.length; index++) {
            productsInput.push(_productsOutput[index]);
        }
        for (uint256 index = 0; index < _productsOutput.length; index++) {
            productsOutput.push(_productsOutput[index]);
        }
        isFinished = false;
        isAccepted = false;
    }

    function acceptTransaction() external {
        if (msg.sender == buyer.owner()) {
            isAccepted = true;
        }
    }

    function finishTransaction() external {
        if (msg.sender == buyer.owner()) {
            isFinished = true;
        }
    }
}
