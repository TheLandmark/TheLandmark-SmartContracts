
// SPDX-License-Identifier: UNLICENSED

/**
       .:+shhdhhyo/-`                    `-/oyhhdhhs+:.      
    ./sdNMMMMMMMMMNmh+-                -+hmNMMMMMMMMMNds/.   
   :smMMMMMMMMMMMMMMMNho-.          .-odNMMMMMMMMMMMMMMMms:  
  /hMMMMMMMMMMNmmmmmmNMMmhs+::--::+shmMMNmmmmmmNMMMMMMMMMMh/ 
 :yMMMMMMMMNdhdmNNNmmdhdNMMNNNNNNNNMMNdhdmmNNNmdhdNMMMMMMMMy:
 omMMMMMMNhhNMMMMMMMMMMmhdmNMMMMMMNmdhmMMMMMMMMMMNhhNMMMMMMmo
 sNMMMMMNydMMMMMMMMNNNNNMNddddddddddNMNNNNNMMMMMMMMdyNMMMMMNs
 omMMMMMhhMMMMMMNmdmmNmmdmNMMNNNNMMNmdmmNmmdmNMMMMMMhhMMMMMmo
 :yMMMMMymMMMMMmdNMMMMMMMNddmNNNNmddNMMMMMMMNdmMMMMMmyMMMMMy:
  /hMMMMymMMMMmhMMMMMMMMMMMMNmmmmNMMMMMMMMMMMMhmMMMMdyMMMMh/ 
   :ymMMmyNMMMdmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmdMMMNymMMmy:  
    .+hNMmymMMmdMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMhmMMmymMNh/.   
     :yNMNhhNMddNMMMMMMMMMMMMMMMMMMMMMMMMMMNddMNhhNMNy:       
       /hMMMdyMMmhNMMMMMMMMMMMMMMMMMMMMMMMMNhmMMydMMMh/      
      /yMMNhhMMhdMMMMMMMMMMMMMMMMMMMMMMMMMMMMdhMMhhNMMy/     
    -+hMMdyNMMmdMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdmMMmydMMh+-   
   /yNMMmyNMMMdmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmdMMMNymMMNy/ 
  +dMMMMymMMMMNhMMMMMMMMMMMNmmmmmmNMMMMMMMMMMMhNMMMMmyMMMMh+
 :hMMMMMymMMMMMmdmMMMMMMMNddNNNNNNddNMMMMMMMmdmMMMMMmyMMMMMy:
 omMMMMMdhMMMMMMNmddmmmddmNMNNNNNNMNmddmmmddmNMMMMMMhdMMMMMmo
 sNMMMMMMydMMMMMMMMMNNNMMmdhddmmddhdmMMNNNMMMMMMMMMdyMMMMMMNo
 omMMMMMMMdhmNMMMMMMMMNmhdNMMMMMMMMNdhmNMMMMMMMMNmhdMMMMMMMmo
 -yNMMMMMMMNdhddmmmmdhhmNMMNNmmmmNNMMNmhhdmmmmddhdNMMMMMMMNy-
  /yNMMMMMMMMMMNmmmmNMMNdyo/:-..-:/oydNMMNmmmmNMMMMMMMMMMNy/ 
   -odMMMMMMMMMMMMMMMNh+-`          `-+hNMMMMMMMMMMMMMMMdo-  
     -ohmMMMMMMMMMNdy/.                ./ydNMMMMMMMMNmho-   
       .-/oyhhhys+:.`                    `.:+syhhhyo/-.      
*/
// Created by Rami Debbas | Mintin
// March 25th 2022
pragma solidity >=0.7.0 <0.9.0;


interface LandToken {
    function balanceOf(address owner) external view returns (uint256 balance);
    
    function allowance(address owner, address spender) external view returns (uint256);
    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract Thelandmark is ERC721Enumerable, Ownable {

    using Strings for uint256;

    string _baseTokenURI;
    string public baseExtension = ".json";
    uint256 public gif = 20;                         //Gift
    uint256 public gifIDs = 1000000000000;           //Gif ID
    uint256 public _maxperWalletWhiteList = 6;       // Whitlist max mint per wallet
    uint256 public _maxperWalletMintPass = 50;       // MintPass max Mint per wallet
    uint256 public _maxperWalletMint = 50;           // Mint max Mint per wallet
    uint256 public _maxperTX = 50;                   // Max per mint
    uint256 public _limit = 10000;                   // Supply of token 
    uint256 public _reserved = 500;                  // Reserved for team and marketing 
    uint256 public _price = 0.15 ether;              // Price 
    uint256 public whitelist_count  =  0;            // Start count for whitelist
    uint256 public mintpass_count  =  0;             // Start count for mintpass
    uint256 public mint_count  =  0;                 // Start count for mint
    bool public _presalePassPaused = true;           // Contract is paused 
    bool public _presaleWLPaused = true;             // Contract is paused 
    bool public _PublicPaused = true;                // Contract is paused 
    mapping (address => uint256) public perWallet;   // Mapping per wallet
    mapping (address => bool) public mintpass;       // Mapping per minpass
    mapping (address => bool) public whitelist;      // Mapping per whitelist
    LandToken public TokenContract;                  // Token functions
    address payable public payments;                 // Paybale 
    bool public isBurningActive = false;             // Paused for Burning Function



   // Constructor for the token 
    constructor(string memory initbaseURI, address _payments) ERC721("The Landmark", "TLM")  {
        require(_payments != address(0), "Zero address error");
        setBaseURI(initbaseURI);
        payments = payable(_payments);
    }
   // Receive function in case someone wants to donate some ETH to the contract
    receive() external payable {}
    // Internal URI 
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
    // Token Public only owner fuctions 
    function setLandToken (LandToken _TokenContract) public onlyOwner{
        // require(_TokenContract != address(0), "Contract address can't be zero address");
        TokenContract = _TokenContract;
    }
    // Public view token 
    function getLandToken(address __address) public view returns(uint256) {
        require(__address != address(0), "Contract address can't be zero address");
        return TokenContract.balanceOf(__address);
    }
    // Get Allowance  public view 
    function getLandAllowance(address __address) public view returns(uint256) {
        require(__address != address(0), "Contract address can't be zero address");
        return TokenContract.allowance(__address, address(this));
    }
    

    // Mint Function public payble 
    function MINT(uint256 num) public payable {
        uint256 supply = totalSupply();
        require( !_PublicPaused,                                     "Sale paused" );
        require( num <= _maxperTX,                                   "You are exceeding limit of per transaction TLM" );
        require( perWallet[msg.sender] + num <= _maxperWalletMint,   "You are exceeding limit of per wallet TLM" );
        require( num > 0);
        require( supply + num <= _limit - _reserved,                 "Exceeds maximum TLM supply" );
        require( msg.value >= _price * num,                          "Ether sent is not correct" );

        for(uint256 i = 1 ; i <= num; i++){
            _safeMint( msg.sender, supply + i );
        }
        perWallet[msg.sender] += num;

    }
    // Giveaway Function external only owner to provide the token for the winners 
    function giveAway(address _to, uint256 _amount) external onlyOwner() {
        require( _to !=  address(0),                                 "Zero address error");
        require( _amount <= _reserved,                               "Exceeds reserved Landmark supply");

        uint256 supply = totalSupply();
        for(uint256 i; i < _amount; i++){
            _safeMint( _to, supply + i );
        }
        _reserved -= _amount;
    }
    // Function mint for gif by the owner to spesfic address 
    function mint_g(address _to, uint256 _amount) external onlyOwner() {
        require( _to !=  address(0),                                 "Zero address error");
        require( _amount <= gif,                                     "Exceeds gif supply" );

        for(uint256 i; i < _amount; i++){
            _safeMint( _to, gifIDs );
            gif --;
            gifIDs++;
        }
    }
    // Internal memory with bublic view for the wallet of owner 
    function walletOfOwner(address _owner) public view returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for(uint256 i; i < tokenCount; i++){
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    // MINTPASS Mint public payable only for the Mintpass Holders 
    function MINTPASS_MINT(uint256 num) public payable {
        uint256 supply = totalSupply();
         require( !_presalePassPaused,                                       "Sale paused" ); 
        require( mintpass[msg.sender] == true,                               "Only MINTPASS can mint" );
        require( perWallet[msg.sender] + num <= _maxperWalletMintPass,       "You are exceeding limit of per wallet TLM" );
        require( supply + num <= _limit - _reserved,                         "Exceeds maximum TLM supply" );
        require( msg.value >= _price * num,                                  "Ether sent is not correct" );

        for(uint256 i; i < num; i++){
            _safeMint( msg.sender, supply + i );
        }
        perWallet[msg.sender] += num;
    }
    // Bulk MintPass wallets 
    function bulk_mintpass(address[] memory addresses) public onlyOwner() {
        for(uint i=0; i < addresses.length; i++){
            address addr = addresses[i];
            if(mintpass[addr] != true && addr != address(0)){
                mintpass[addr] = true;
                mintpass_count++;
            }
        }
    }
    // Function remove MitPass wallet / only owner 
    function remove_mintpass(address _address) public onlyOwner() {
        require(_address != address(0),                                       "Zero address error");
        mintpass[_address] = false;
        mintpass_count--;
    }

    // Whitlist Mint public payable only for the whitlisted people 
    function WHITELIST_MINT(uint256 num) public payable {
        uint256 supply = totalSupply();
        require( !_presaleWLPaused,                                             "Sale paused" ); 
        require( whitelist[msg.sender] == true,                                 "Only WHITELIST can mint" );
        require( perWallet[msg.sender] + num <= _maxperWalletWhiteList,         "You are exceeding limit of per wallet TLM" );
        require( supply + num <= _limit - _reserved,                            "Exceeds maximum TLM supply" );
        require( msg.value >= _price * num,                                     "Ether sent is not correct" );

        for(uint256 i; i < num; i++){
            _safeMint( msg.sender, supply + i );
        }
        perWallet[msg.sender] += num;
    }
    // Bulk Whitlist wallets 
    function bulk_whitelist(address[] memory addresses) public onlyOwner() {
        for(uint i=0; i < addresses.length; i++){
            address addr = addresses[i];
            if(whitelist[addr] != true && addr != address(0)){
                whitelist[addr] = true;
                whitelist_count++;
            }
        }
    }
    // Function remove whiltlist wallet / only owner 
    function remove_whitelist(address _address) public onlyOwner() {
        require(_address != address(0),                                        "Zero address error");
        whitelist[_address] = false;
        whitelist_count--;
    }
    
    // Just in case Eth does some crazy stuff ( Change price ) only owner 
    function setPrice(uint256 _newPrice) public onlyOwner() {
        _price = _newPrice;
    }


    // Setting limits 
    function setLimit(uint256 limit) public onlyOwner {
        _limit = limit;
    }
    // Max per wallet
    function setMaxPerWallet(uint256 limit) public onlyOwner {
        _maxperTX = limit;
    }

    // token URI
   function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    string memory currentBaseTokenURI = _baseURI();
    return bytes(currentBaseTokenURI).length > 0
        ? string(abi.encodePacked(currentBaseTokenURI, tokenId.toString(), baseExtension))
        : "";
  }
   // Burn Function 
    function burnForMint(uint256 _tokenId) public {
        require(isBurningActive, "Burning not active");
        require(ownerOf(_tokenId) == msg.sender);
        //Burn token
        _transfer(
            msg.sender,
            0x000000000000000000000000000000000000dEaD,
            _tokenId
        );
    }
    // Pause Burn 
    function toggleBurningActive() public onlyOwner {
        isBurningActive = !isBurningActive;
    }
    // Price show public 
    function getPrice() public view returns (uint256){
        return _price;
    }
    // Public set URI if needed 
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    // Pause contract public  only owner

    function presalePassPaused() public onlyOwner {
        _presalePassPaused = !_presalePassPaused;
    }
    function presaleWLPaused() public onlyOwner {
        _presaleWLPaused = !_presaleWLPaused;
    }
     function PublicPaused() public onlyOwner {
        _PublicPaused = !_PublicPaused;
    }
 
    // Withrow fund 
    function withdrawAll() public payable onlyOwner {
        (bool success, ) = payable(payments).call{value: address(this).balance}("");
    require(success);
    }
}