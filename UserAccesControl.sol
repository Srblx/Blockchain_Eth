// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureLinkStorage {
    // Adresse du propriétaire du contrat
    address public owner;
    
    // Mapping pour stocker les liens autorisés sous forme de hachages
    mapping(bytes32 => bool) private authorizedLinks;

    // Modificateur pour restreindre certaines fonctions au propriétaire
    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le propriétaire peut effectuer cette action");
        _;
    }

    constructor() {
        // L'adresse qui déploie le contrat devient le propriétaire
        owner = msg.sender;
    }

    // Fonction pour ajouter un lien autorisé
    function addAuthorizedLink(bytes32 linkHash) public onlyOwner {
        authorizedLinks[linkHash] = true;
    }

    // Fonction pour supprimer un lien autorisé
    function removeAuthorizedLink(bytes32 linkHash) public onlyOwner {
        authorizedLinks[linkHash] = false;
    }

    // Fonction pour vérifier si un lien est autorisé
    function isLinkAuthorized(bytes32 linkHash) public view returns (bool) {
        return authorizedLinks[linkHash];
    }
}

contract UserAccessControl {
    // Adresse du contrat SecureLinkStorage
    SecureLinkStorage public linkStorage;

    constructor(address _linkStorageAddress) {
        // Lie ce contrat à l'adresse du contrat SecureLinkStorage
        linkStorage = SecureLinkStorage(_linkStorageAddress);
    }

    // Fonction pour demander l'accès à un lien
    function requestLinkAccess(bytes32 linkHash) public view returns (bool) {
        return linkStorage.isLinkAuthorized(linkHash);
    }
}
