pragma solidity >=0.7.0 <0.9.0;

contract ConsultationEnLigne {
    
    struct Consultation {
        uint id;
        address patient;
        address doctor;
        uint date;
        uint256 prix;
        bool payee;
        bool validee;
        Laboratoire[] laboratoires;
        Prescription Ordannace; 
    }

    struct Laboratoire {
        string name;
        uint id;
        address laboratoire;
        string nom;
        string adresse;
    }

    struct Prescription {
        uint id;
        address patient;
        address doctor;
        Medecin[] Medecin;
    }
    
    struct Medecin {
        uint id;
        string nom;
        uint prix ;
    }

    Consultation[] public consultations;
    address public proprietaire;
    mapping(address => bool) public medecins;
    mapping(address => Pharmacie) public pharmacies;
    mapping(uint => Laboratoire) public laboratoires;
    
    event NouvelleConsultation(uint indexed id, string patient, address indexed medecin, uint date, uint256 prix);
    event PaiementConsultation(uint indexed id);
    event ValidationConsultation(uint indexed id);
    
    constructor() {
        proprietaire = msg.sender;
    }
    
    modifier seulementProprietaire() {
        require(msg.sender == proprietaire, " Seul le proprietaire peut effectuer cette action.");
        _;
    }
    
    function ajouterMedecin(address _medecin) public seulementProprietaire {
        medecins[_medecin] = true;
    }
    
    function enleverMedecin(address _medecin) public seulementProprietaire {
        medecins[_medecin] = false;
    }
    
    function nouvelleConsultation(string memory _patient, uint[] memory _pharmacies, uint[] memory _laboratoires, uint256 _prix) public {
        require(medecins[msg.sender] == true, "Vous n'etes pas autorise a ajouter une consultation.");
        require(_pharmacies.length > 0 && _laboratoires.length > 0, "Vous devez specifier au moins une pharmacie et un laboratoire.");
        uint id = consultations.length;
        consultations.push(Consultation(id, _patient, msg.sender, block.timestamp, _prix, false, false, _pharmacies, _laboratoires));
        emit NouvelleConsultation(id, _patient, msg.sender, block.timestamp, _prix);
    }
    
    function payerConsultation(uint _id) public payable {
        require(msg.value == consultations[_id].prix, "Le montant paye ne correspond pas au prix de la consultation.");
        require(consultations[_id].payee == false, "La consultation a deja ete payee.");
        consultations[_id].payee = true;
        emit PaiementConsultation(_id);
    }
    
    function validerConsultation(uint _id) public seulementProprietaire {
        require(consultations[_id].validee == false, "La consultation a deja ete validee.");
        require(consultations[_id].payee == true, "La consultation n'a pas encore ete payee.");
        consultations[_id].validee = true;
        payable(consultations[_id].medecin).transfer(consultations[_id].prix);
        for (uint i = 0; i < consultations[_id].pharmacies.length; i++) {
            pharmacies[consultations[_id].pharmacies[i]].adresse.transfer(consultations[_id].prix / consultations[_id].pharmacies.length);
        }
    }    