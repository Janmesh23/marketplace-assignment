// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./NFTminting.sol";
import "./TokenConverter.sol";


contract Marketplace{

    mapping(uint256 => uint256) private Price;
    mapping(address => uint256[]) private  purchase;
    mapping(address => uint256[]) private purchaseprice;
    // uint256[] private list;
    mapping(uint256 => bool) private forsale;
    mapping(uint256 => bool) private _sold;
    uint256 private fsm=0;
    YourNFT public minter;
    MyTokens public converter;
    

    constructor(address _minterAddress,address _converterAddress) {
        require(_minterAddress!=address(0),"Contract doesn't exist");
        require(_converterAddress!=address(0),"Contract doesn't exist");
        minter = YourNFT(_minterAddress);
        converter = MyTokens(_converterAddress);
    }
    /*
    ===============================
    Show all the nft owned my user
    ===============================
    */
    function MyNFT() external view returns(uint256[] memory){
        address user = msg.sender;
        return minter.MyNFT(user);
    }
    /*
    ===============================
    Show Particular NFT Detail
    ===============================
    */
    function NFTDetail(uint256 _tokenId) public view returns(string memory name,string memory description,string memory uri,address creator,string memory salesStatus){
        (name,description,uri,creator) = minter.getNFTMetaData(_tokenId);
        // bool check=false;
        // for(uint256 i=0;i<list.length;++i){
        //     if(list[i] == _tokenId){
        //         check=true;
        //         break;
        //     }
        // }
        if(forsale[_tokenId]==true){
            salesStatus = "For Sale";
        }
        else{
            salesStatus = "Not for Sale";
        }
        return (name,description,uri,creator,salesStatus);
    }
    /*
    ===============================
    Sell NFT in Market
    ===============================
    */
    function SellYourNFT(uint256 _tokenId,uint256 _price) external {
        address user=msg.sender;
        require(minter.ownerOf(_tokenId)==user,"You are not the owner of this NFT");
        Price[_tokenId] = _price;
        // list.push(_tokenId);
        forsale[_tokenId]= true;
        _sold[_tokenId]=false;
        if(_tokenId>fsm) fsm=_tokenId;
    }
    /*
    ===============================
    Buy NFT from Market
    ===============================
    */
    function BuyNFT(uint256 _tokenId) external payable{
        address user=msg.sender;
        require(forsale[_tokenId]==true,"Not for Sale");
        require(converter.balanceOf(user)>=Price[_tokenId],"Insuffcient Token");
        converter.transferFrom(user,minter.ownerOf(_tokenId), Price[_tokenId]);
        minter.transferFrom(minter.ownerOf(_tokenId),user,_tokenId);
        forsale[_tokenId]=false;
        _sold[_tokenId]=true;
        purchase[user].push(_tokenId);
        purchaseprice[user].push(Price[_tokenId]);
    }
    /*
    ===============================
    All for sale NFTs
    ===============================
    */
    
     
    function forSaleNFT() public view returns (uint256[] memory) {
    uint256 count;

    for (uint256 i = 0; i <= fsm; i++) {
        if (forsale[i]==true) {
            count++;
        }
    }

    uint256[] memory ids = new uint256[](count);
    uint256 index=0;

    for (uint256 i = 0; i <= fsm; i++) {
        if (forsale[i]==true) {
            ids[index] = i;
            index++;
        }
    }

    return ids;
}

    /*
    ===============================
    All Sold NFTs
    ===============================
    */
    function SoldOutNFT() public view returns(uint256[] memory){
        uint256 count;

    for (uint256 i = 0; i <= fsm; i++) {
        if (_sold[i]==true) {
            count++;
        }
    }

    uint256[] memory ids = new uint256[](count);
    uint256 index=0;

    for (uint256 i = 0; i < fsm; i++) {
        if (_sold[i]==true) {
            ids[index] = i;
            index++;
        }
    }

    return ids;
    }
    /*
    ===============================
    Price of NFT
    ===============================
    */
    function PriceNft(uint256 _tokenId) public view returns(uint256 price){
        require(forsale[_tokenId]==true,"Not for Sale");
        price=Price[_tokenId];
        return (price);


    }
    /*
    ===============================
    Recent Purchase
    ===============================
    */
    function recentPurchase() public view returns(uint256[] memory tokenId, uint256[] memory price){
        // uint256 count;
        address user=msg.sender;

    return (purchase[user],purchaseprice[user]);
    }

}