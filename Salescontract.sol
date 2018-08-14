pragma solidity ^0.4.17;

contract SalesContract {
    address owner;
    
   struct Offer{
        uint price;
        string product_description;
        uint quantity_offered;
        bool onSale;
        address owner_address;
        uint256 updatedTime;
    }
    mapping (address => Offer) public offers;
    
    event UserStatus(string _msg, address user, uint amount, uint256 time);
    
    function setoffers(address _owner_address, uint _price, string _description, uint _quantity_offered) payable{
        var offer = offers[_owner_address];
        offer.price=_price;
        offer.product_description=_description;
        offer.quantity_offered=_quantity_offered;
        offer.onSale=true;
        offer.owner_address=_owner_address;
        offer.updatedTime = block.timestamp;
        UserStatus(offer.product_description, msg.sender, msg.value, block.timestamp);
        UserStatus('Item on Sale:', msg.sender, msg.value, block.timestamp);
    }
    
    function getoffers(address _owner_address) view public returns(uint, string, uint, bool, uint256){
        return(offers[_owner_address].price,offers[_owner_address].product_description,offers[_owner_address].quantity_offered, offers[_owner_address].onSale,offers[_owner_address].updatedTime);
    }

    function buy(address _owner_address) payable {
        
        require(block.timestamp > offers[_owner_address].updatedTime && msg.value >= offers[_owner_address].price && offers[_owner_address].onSale == true);
            owner = _owner_address;
            owner.transfer(this.balance);
            offers[_owner_address].onSale = false;
            UserStatus('Item Bought - No Longer on Sale', msg.sender, msg.value, block.timestamp);
            offers[_owner_address].updatedTime = block.timestamp; 
    }

    function updateQuantity(address _owner_address ,uint _quantity) onlyOwner(_owner_address) {
        offers[_owner_address].quantity_offered=_quantity;
        UserStatus('Quantity Updated', offers[_owner_address].owner_address, 0, offers[_owner_address].updatedTime);
    }
    
    function updatePrice(address _owner_address, uint _price) onlyOwner(_owner_address) {
        offers[_owner_address].price=_price;
        UserStatus('Price Updated', offers[_owner_address].owner_address, offers[_owner_address].price, offers[_owner_address].updatedTime);
    }

    function modifyDescription(address _owner_address, string _description) onlyOwner(_owner_address) {
        offers[_owner_address].product_description = _description;
        UserStatus(offers[_owner_address].product_description, offers[_owner_address].owner_address, 0, offers[_owner_address].updatedTime);
        UserStatus('Description Modified', offers[_owner_address].owner_address, 0, offers[_owner_address].updatedTime);
    }

    function putOnSale(address _owner_address) onlyOwner(_owner_address) {
        offers[_owner_address].onSale = true;
        UserStatus('Item Now is On Sale', offers[_owner_address].owner_address, 0, offers[_owner_address].updatedTime);
    }

    function removeFromSale(address _owner_address) onlyOwner(_owner_address) {
        offers[_owner_address].onSale = false;
        UserStatus('Item No Longer on Sale', offers[_owner_address].owner_address, 0, block.timestamp);
    }

    modifier onlyOwner (address _owner_address) {
        require (msg.sender == _owner_address);
        offers[_owner_address].updatedTime = block.timestamp;
        _;
    }
}