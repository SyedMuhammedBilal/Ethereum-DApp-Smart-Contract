// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Sofi {
    string public name = "Sofi";
    uint public imageId = 0;

    struct Image {
        uint id;
        string hash;
        string description;
        uint tipAmount;
        address payable author;
    }

    mapping (uint => Image) public images;

    event ImageUploaded(
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
    );

    event TipOnPost(
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
    );

    function uploadImage(string memory _imageHash, string memory _desc) public {
        require(msg.sender != address(0x0));
        require(bytes(_imageHash).length > 0);
        require(bytes(_desc).length > 0);
        imageId++;
        images[imageId] = Image(imageId, _imageHash, _desc, 0, payable(msg.sender));
        emit ImageUploaded(imageId, _imageHash, _desc, 0, payable(msg.sender));
    }

    function tipPostOwner(uint _id) public payable {
        require(_id != 0 && _id <= imageId);
        // fetches the images mapping
        Image memory _image = images[_id]; 
        // fetch the author (owner of the post)
        address payable _author = _image.author;
        // tipping author by paying them ether 
        _author.transfer(msg.value);    
        // increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;
        // update the image mapping
        images[_id] = _image;

        emit TipOnPost(_id, _image.hash, _image.description, _image.tipAmount, _author);
    }
}