// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract OrganDoanation {
address public ProcurementOrganizer;
address public OrganMatchingOrganizer;
mapping(address => bool) public TransplantTeamMember; // only authorized Hospital Transplant Team Members are allowed
mapping(address => bool) public PatientDoctor; 
uint public Donor_ID;
uint public Donor_BloodType;
uint public Donor_OrganType;
uint public Min_Age;
uint public Max_Age;
uint public Donor_MinBMI;
uint public Donor_MaxBMI;
uint public Patient_ID; // address Patient_EA; 
uint public Patient_Age;
uint public Patient_BMI;
mapping(uint => bool) public PatientValidity; //Used to ensure that patient selection is not repeated
uint [] public NeededOrganType;
uint [] public PatientsID;
uint []  public Patients_age;
uint [] public Blood_type;
uint [] public BMI;
uint [] public Matched; 
uint public startTime;
enum Bloodtype {A, B, AB, O}
Bloodtype public Bloodtype_;
enum OrganType {Heart, Lung, Liver, Kidney}
OrganType public _OrganType_;

// Events
event MatchingProcessStarted (address PatientDoctor);
event NewPatient_AddedOnTheWaitingList (address PatientDoctor, uint Patient_ID, uint Patient_Age, uint Patient_BMI, Bloodtype Bloodtype_ , OrganType _OrganType_); 
event MedicalTestApproval (address TransplantTeamMember, uint Donor_ID); 
event DonatedHeartisAvailable (address ProcurementOrganizer, uint Donor_ID, OrganType _OrganType_);
event NewMatchedOrgan (address ProcurementOrganizer);

constructor()  {
    ProcurementOrganizer = msg.sender;
    OrganMatchingOrganizer= 0x8B0ed0582Af7A86E90A7CD0F6e1228f03B6b9A72;
    startTime = block.timestamp;
    emit MatchingProcessStarted(ProcurementOrganizer);
}


//Defining Modifiers 
modifier onlyPatientDoctor() {
    require(PatientDoctor[msg.sender], "The sender is not eligible to run this function");
    _;
}
modifier onlyTransplantTeamMember() {
    require(TransplantTeamMember[msg.sender], "The sender is not eligible to run this function");
    _;
}
modifier onlyProcurementOrganizer() {
    require(ProcurementOrganizer == msg.sender, "The sender is not eligible to run this function");
    _;
}
modifier onlyOrganMatchingOrganizer() {
    require(OrganMatchingOrganizer == msg.sender, "The sender is not eligible to run this function");
    _;
}
// Hospital Transplant Team Members Authorization Function
    function AssigningPatientDoctors (address user) public onlyProcurementOrganizer {
        PatientDoctor[user]=true;
    }
    function getPatientDoctorTest (address user) public view returns(bool) {
        require(PatientDoctor[user], "user does not exist in the mapping.");
        return PatientDoctor[user];
    }
     function AssigningTransplantTeamMember (address user) public onlyProcurementOrganizer {
        TransplantTeamMember [user]=true;
    } 
    function getTransplantTeamMemberTest (address user) public view returns(bool) {
        require(TransplantTeamMember[user], "user does not exist in the mapping.");
        return TransplantTeamMember[user];
    }


    function AddingNewPatient(uint ID, uint _age, uint _BMI, uint _BloodType, uint _OrganType) public onlyPatientDoctor{
    Patient_ID = ID;
    Patient_Age = _age;
    Patient_BMI= _BMI;
    Bloodtype_ = Bloodtype(_BloodType);
    _OrganType_ = OrganType(_OrganType);
    PatientsID.push(Patient_ID);
    NeededOrganType.push(_OrganType);
    Patients_age.push(Patient_Age);    
    Blood_type.push(_BloodType);
    BMI.push(Patient_BMI);
        emit NewPatient_AddedOnTheWaitingList(msg.sender, Patient_ID, Patient_Age, Patient_BMI, Bloodtype_ , _OrganType_);
    
    }
    
    function TestApproval(uint DonorID) public onlyTransplantTeamMember{
        Donor_ID = DonorID;
        emit MedicalTestApproval(msg.sender, Donor_ID); 
    }
    function RegisteringNewDonor (uint DonorID, OrganType _OrganType ) public onlyProcurementOrganizer{
        Donor_ID = DonorID;
        _OrganType_ = OrganType(_OrganType);
        emit DonatedHeartisAvailable(msg.sender, Donor_ID,  _OrganType_ );
    }

    function MatchingProcess (uint _MinAge, uint _MaxAge, uint _BloodType, uint _MinBMI, uint _MaxBMI, uint _OrganType) public onlyOrganMatchingOrganizer{
        Min_Age = _MinAge;
        Max_Age = _MaxAge;
        Donor_BloodType = _BloodType;
        Donor_OrganType = _OrganType;
        Donor_MinBMI = _MinBMI;
        Donor_MaxBMI = _MaxBMI;
        
         for (uint i = 0; i < PatientsID.length; i++ ) {
             require(PatientValidity[PatientsID[i]]==false, "The patient has already been matched with a donor");
            if ( 
            NeededOrganType[i] == _OrganType &&
            Patients_age[i]> Min_Age &&
            Patients_age[i] < Max_Age &&
            Blood_type[i] == _BloodType &&
            BMI[i]> Donor_MinBMI &&
            BMI[i] < Donor_MaxBMI) 
            { 
              Matched.push(PatientsID[i]);
              PatientValidity[PatientsID[i]]=true; 
            }
         }
    emit NewMatchedOrgan (msg.sender);          
    }}