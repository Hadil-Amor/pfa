// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract OrganTransplantation{
        
        OrganStatus public Organstate;
        uint startTime;
        uint Donor_ID;
        uint PatientID;
        uint Removing_time;
        uint Removing_date;
        uint TransplantationDate;
        uint  TransplantationTime;
        enum OrganType {Heart, Lung, Liver, Kidney}
        OrganType public DonatedOrganType;
        
        //Events
        event TransplantationProcessStarted (address indexed DonorSurgeon);
        event DonatedHeartisRemoved(address DonorSurgeon, uint Donor_ID);
        event DonatedLiverisRemoved(address DonorSurgeon, uint Donor_ID);
        event DonatedkidneyisRemoved(address DonorSurgeon, uint Donor_ID);
        event DonatedlungisRemoved(address DonorSurgeon, uint Donor_ID);
        event DeliveryStart (address transporter); 
        event DeliveryEnd(address transporter); 
        event DonatedOrganisReceived (address indexed TransplantSurgeon);
        event Transplantationend(address TransplantSurgeon, uint PatientID, uint TransplantationTime, uint TransplantationDate);
        
    constructor() {
    TransplantSurgeon = msg.sender;
    DonorSurgeon =0xff530A0E0E3c59C2b293479429aeC1a6a2eec486;
    startTime = block.timestamp;
    Organstate = OrganStatus.NotReady;
    emit TransplantationProcessStarted(msg.sender);
}

modifier onlyDonorSurgeon() {
    require(DonorSurgeon == msg.sender, "The sender is not eligible to run this function");
    _;
}
modifier onlyTransplantSurgeon() {
    require(TransplantSurgeon == msg.sender, "The sender is not eligible to run this function");
    _;
}

modifier onlytransporter() {
    require(transporter[msg.sender], "The sender is not eligible to run this function");
    _;
}
// Transporter Authorization Function

       function assigningtransporter (address user) public onlyDonorSurgeon{
        transporter [user]=true;
    }
       function getTransporterTest (address user) public view returns(bool) {
        require(transporter[user], "user does not exist in the mapping.");
        return transporter[user];
    }
       function RemovingDonatedOrgan(uint donorID, OrganType _DonatedOrganType, uint date, uint time ) public onlyDonorSurgeon{
        Donor_ID= donorID;
        Removing_date = date;
        Removing_time = time; 
        require(Organstate == OrganStatus.NotReady, "Donated Organ is already removed");
        Organstate = OrganStatus.ReadyforDelivery;
         if (_DonatedOrganType == OrganType.Heart){
        
        emit DonatedHeartisRemoved(msg.sender, Donor_ID);
    }
       
         if (_DonatedOrganType == OrganType.Lung){
        
        emit DonatedlungisRemoved(msg.sender,Donor_ID);
    }
            
         if (_DonatedOrganType == OrganType.Liver){
        
        emit DonatedLiverisRemoved(msg.sender,Donor_ID);
    }
         
         if (_DonatedOrganType == OrganType.Kidney){
        
        emit DonatedkidneyisRemoved(msg.sender,Donor_ID);
    }
    
    }
       function StartDelivery() public onlytransporter{
        require(Organstate == OrganStatus.ReadyforDelivery, "Can't start delivery before removing the organ");
         Organstate = OrganStatus.onTrack;
        emit DeliveryStart(msg.sender);
    }
    
    function EndDelivery() public onlytransporter{
        require(Organstate == OrganStatus.onTrack, "Can't end delivery before announcing the start of it");
        Organstate = OrganStatus.EndDelivery;
        emit DeliveryEnd(msg.sender);
        
    }
    function ReceiveDonatedOrgan() public onlyTransplantSurgeon{
        require(Organstate == OrganStatus.EndDelivery, "Can't receive the donated Organ unit before announcing the end of the delivery");
        Organstate = OrganStatus.OrganReceived;
        emit DonatedOrganisReceived(msg.sender);
    }
        function Organ_Transplantation(uint ID, uint Date, uint Time) public onlyTransplantSurgeon{
         PatientID = ID;
         TransplantationDate = Date; 
         TransplantationTime = Time;
        emit Transplantationend(msg.sender, PatientID, TransplantationTime, TransplantationDate);
    }
    
    }