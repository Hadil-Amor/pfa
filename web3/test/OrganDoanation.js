const Web3 = require('web3');
const web3 = new Web3('http://localhost:7545');
const OrganDoanation = artifacts.require('OrganDoanation');

contract('OrganDoanation', (accounts) => {
  let instance;
  let procurementOrganizer = accounts[0];
  let patientDoct = accounts[1];
  let organmatchinfOrganizer = accounts[2];
  let transplantTeamMember = accounts[3];


  beforeEach(async () => {
    instance = await OrganDoanation.deployed({ from: procurementOrganizer });
  });
  
  it('should allow the procurement organizer to assign a patient doctor', async () => {
    await instance.AssigningPatientDoctors(patientDoct,{ from: procurementOrganizer });
    let isPatientDoctor = await instance.getPatientDoctorTest (patientDoct);
    assert.isTrue(isPatientDoctor);
    
  });
  it('should allow the procurement organizer to assign a Transplant team member', async () => {
    await instance.AssigningTransplantTeamMember(transplantTeamMember, { from: procurementOrganizer });
    let isTransplantTeamMember = await instance.getTransplantTeamMemberTest(transplantTeamMember);
    assert.isTrue(isTransplantTeamMember);
  });
  it('should add new patient to waiting list', async () => {
    const patientId = 1;
    const patientAge = 30;
    const patientBMI = 25;
    const bloodType = 0; // A
    const organType = 2; // Liver
    await instance.AddingNewPatient(patientId, patientAge, patientBMI, bloodType, organType, { from: patientDoct });
    const addedPatient = await instance.PatientsID.call(0);
    assert.equal(addedPatient, patientId, 'Failed to add new patient');
  });

  it('should register new donor', async () => {
    const donorId = 1;
    const organType = 2; // Liver
    await instance.RegisteringNewDonor(donorId, organType, { from: procurementOrganizer });
    const addedDonor = await instance.Donor_ID.call();
    assert.equal(addedDonor, donorId, 'Failed to register new donor');
  });

  it('should approve medical test', async () => {
    const donorId = 1;
    await instance.TestApproval(donorId, { from: accounts[3] });
    const approvedDonor = await instance.Donor_ID.call();
    assert.equal(approvedDonor, donorId, 'Failed to approve medical test');
  });

  it('should match a patient with a donor', async () => {
    const minAge = 20;
    const maxAge = 50;
    const bloodType = 0; // A
    const minBMI = 20;
    const maxBMI = 30;
    const organType = 2; // Liver
    await instance.MatchingProcess(minAge, maxAge, bloodType, minBMI, maxBMI, organType, { from: organmatchinfOrganizer});
    const matchedPatient = await instance.Matched.call(0);
    assert.equal(matchedPatient, 1, 'Failed to match a patient with a donor');
  });
});