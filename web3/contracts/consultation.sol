// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Diagnostic {

    struct Patient {
        address Patient_add;
        string name;
        string bloodtype;
        uint weight;
        uint height;
        uint age;
    }

    struct Analyse {
        uint id; //auto incriment
        string name;
        address patient;
        address doctor;
        string resultat;
        uint price;
        bool paid;
    }

    struct Record { // auto incriment
        uint id;
        address p;
        uint[] test_id;
        Prescription prescription;
        string status;
        uint diagnostic_time;
        address doctor;
    }

    struct Prescription {
        uint id_rec;
        address doctor;
        address pharmacie;
        uint[] medecines_id;
        uint price;
        bool isPaid;
        bool isDelivered;
        address deliveryAddress;
    }

    struct Medecine {
        uint id; //auto incriment 
        string name; 
        string dosage;
        uint duration;
        string instructions;
    }
    struct AppointmentRequest {
        address client;
        address medecin;
        string date;
        bool accepted;
    }
    
    mapping(address => Patient) public patient_information;
    mapping(address => Prescription[]) public pharmacie_prescriptions;
    mapping(address => Analyse[]) public patient_analyses;
    mapping(address => AppointmentRequest[]) public appointmentRequests;
    mapping(address => Record[]) public patient_records;
    mapping(address =>mapping(uint => Medecine[])) public patient_medecines;
    mapping(address => bool) public patients;
    mapping(address => bool) public doctors;
    mapping(address => bool) public pharmacy;
    mapping(address => bool) public laboratories;
    mapping(address => Analyse[]) public laboratory_analyses;
    address private manager;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(manager == msg.sender, "The sender is not eligible to run this function");
        _;
    }

    modifier onlypatient() {
        require(patients[msg.sender], "The sender is not eligible to run this function");
        _;
    }

    modifier onlydoctor() {
        require(doctors[msg.sender], "The sender is not eligible to run this function");
        _;
    }

    modifier onlylaboratory() {
        require(laboratories[msg.sender], "The sender is not eligible to run this function");
        _;
    }

    modifier onlypharmacy() {
        require(pharmacy[msg.sender], "The sender is not eligible to run this function");
        _;
    }

    function assigningdoctor(address user) public onlyManager {
        doctors[user] = true;
    }

    function assigninglaboratory(address user) public onlyManager {
        laboratories[user] = true;
    }

    function assigningpharmacy(address user) public onlyManager {
        pharmacy[user] = true;
    }
    //Patient & Doctor 
    function prendreRendezVous(address _medecin, string memory _date) public {
        AppointmentRequest memory request = AppointmentRequest({
            client: msg.sender,
            medecin: _medecin,
            date: _date,
            accepted: false
        });

        appointmentRequests[_medecin].push(request);
    }

    function accepterRendezVous(uint index) public onlydoctor{
        AppointmentRequest storage request = appointmentRequests[msg.sender][index];
        require(!request.accepted, "The appointment has already been accepted.");

        request.accepted = true;
    }

    function refuserRendezVous(uint index) public onlydoctor {
        AppointmentRequest storage request = appointmentRequests[msg.sender][index];
        
        require(!request.accepted, "The appointment has already been rejected.");

        delete appointmentRequests[request.medecin][index];
    }
    function addPatientRecord(address _patient_add, string memory _name, string memory _bloodtype, uint _weight, uint _height, uint _age) public onlydoctor {
        patients[_patient_add] = true;
        Patient memory p;
        p.Patient_add = _patient_add;
        p.name = _name;
        p.bloodtype = _bloodtype;
        p.weight = _weight;
        p.height = _height;
        p.age = _age;
        patient_information[_patient_add]=p;
        
        patient_records[_patient_add].push(Record({
        id: patient_records[_patient_add].length,
        p:  _patient_add,
        test_id: new uint[](0),
        prescription:Prescription({
        id_rec:patient_records[_patient_add].length,    
        doctor:msg.sender,
        pharmacie: address(0),
        medecines_id:new uint[](0),
        price :0,
        isPaid:false,
        isDelivered:false,
        deliveryAddress: address(0)

        }) ,
        status: "",
        diagnostic_time: block.timestamp,
        doctor: msg.sender
        }));
    }
    function ask_for_analyse( string memory analyse_name,uint id_record, address p, address lab) public onlydoctor{
         
         Analyse memory a = Analyse({
             id: patient_analyses[p].length,
             name: analyse_name,
             patient: p,
             doctor: msg.sender,
             resultat: "",
             price: 0,
             paid: false
         });
        require(laboratories[lab],"invalid laboratory"); 
        laboratory_analyses[lab].push(a);
        uint[] memory test_id_new = new uint[](patient_records[p][id_record].test_id.length + 1);
        for (uint i = 0; i < patient_records[p][i].test_id.length; i++) {
              test_id_new[i] = patient_records[p][id_record].test_id[i];
                  }
        test_id_new[test_id_new.length - 1] = id_record;
        patient_records[p][id_record].test_id = test_id_new;
    }
   
    function SendAnalyse_to_the_patient(address p, uint id_analyse, string memory result, uint price) public onlylaboratory{
       Analyse[] memory analyses_recived =  laboratory_analyses[msg.sender];
       for(uint i = 0; i<analyses_recived.length; i++){
           if(analyses_recived[i].patient==p && analyses_recived[i].id ==id_analyse && analyses_recived[i].paid )
           {
               analyses_recived[i].resultat=result;
               analyses_recived[i].price=price;
               laboratory_analyses[msg.sender][i]=analyses_recived[i];
               patient_analyses[p].push(analyses_recived[i]);
               break;
           }
       }

    }

    function View_analyse_doctor (address p, uint id) public view onlydoctor returns(Analyse memory) {
        Analyse memory a;
        Analyse[] memory analyses_done = patient_analyses[p];
        for(uint i = 0; i<analyses_done.length; i++){
           if(  analyses_done[i].id ==id )
           {
               return analyses_done[i];
           }
        }
        return a;
    }
    function view_analyse_patient ( uint id) public view onlypatient returns(Analyse memory) {
        Analyse memory a;
        Analyse[] memory analyses_done = patient_analyses[msg.sender];
       for(uint i = 0; i<analyses_done.length; i++){
           if(  analyses_done[i].id ==id )
           {
               return analyses_done[i];
           }
        }
        return a;
    }

    function pay_analyse (uint id,address payable lab ) public onlypatient payable{
        require(laboratories[lab],"invalid laboratory"); 
        Analyse memory a ;
        uint index;
        Analyse[] memory analyses_done = laboratory_analyses[lab];
        for(uint i = 0; i<analyses_done.length; i++){
           if(  analyses_done[i].patient ==msg.sender && analyses_done[i].id ==id )
           {
               a= analyses_done[i];
               index=i;
           }
        }
         require(!a.paid,"Analyse already paid");
         require(address(this).balance >= a.price);
         require(msg.value == a.price);
         lab.transfer(a.price);
         a.paid=true;
         laboratory_analyses[lab][index]=a;
    }

    //Pharmacie Patient Doctor
    function add_medecine(uint id_rec ,address patient, string memory name, string memory dosage, uint duration, string memory inst  )public onlydoctor{
        patient_records[patient][id_rec].prescription.medecines_id.push(patient_medecines[patient][id_rec].length);
        patient_medecines[patient][id_rec].push(Medecine(patient_medecines[patient][id_rec].length,name,dosage,duration,inst));
    }
    function approve_pharmacy(address pharmacie,uint id_rec) public onlypatient{
        patient_records[msg.sender][id_rec].prescription.pharmacie=pharmacie;
        pharmacie_prescriptions[pharmacie].push(patient_records[msg.sender][id_rec].prescription);
    }
    function read_medecine(address patient,uint id_rec)public view onlypharmacy returns(Medecine[] memory){
        return patient_medecines[patient][id_rec];
    }
    function add_prescription_price(uint id,address patient,uint price) public onlypharmacy {
        require(patient_records[msg.sender][id].prescription.pharmacie==msg.sender,"You're not allowed to see prescription");
              patient_records[patient][id].prescription.price=price;
        }
    
    function pay_prescription (uint id,address payable phar ) public onlypatient payable {
        require(patient_records[msg.sender][id].prescription.pharmacie==phar,"invalid pharmacy"); 
        require(!patient_records[msg.sender][id].prescription.isPaid,"Prescription already paid");
        require(address(this).balance >= patient_records[msg.sender][id].prescription.price);
        require(msg.value == patient_records[msg.sender][id].prescription.price);
        phar.transfer(patient_records[msg.sender][id].prescription.price);
        patient_records[msg.sender][id].prescription.isPaid=true;
    }
    function setDeliveryAddress(uint id_rec, address deliveryAddress) public onlypatient {
    Prescription[] storage prescriptions = pharmacie_prescriptions[msg.sender];
    require(id_rec < prescriptions.length, "Invalid prescription ID");

    prescriptions[id_rec].deliveryAddress = deliveryAddress;
    }
    function deliverMedicines(uint id_rec) public onlypharmacy {
    Prescription[] storage prescriptions = pharmacie_prescriptions[msg.sender];
    require(id_rec < prescriptions.length, "Invalid prescription ID");
    Prescription storage prescription = prescriptions[id_rec];
    require(prescription.pharmacie == msg.sender, "Invalid pharmacy");
    prescription.isDelivered = true;
}
}