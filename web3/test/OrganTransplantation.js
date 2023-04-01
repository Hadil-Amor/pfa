const Web3 = require('web3');
const web3 = new Web3('http://localhost:7545');
const OrganTransplantation = artifacts.require('OrganTransplantation');

contract('OrganTransplantation', (accounts) => {
  let instance;
  let TransplantSurgeon = accounts[0];
  let donorsurgeon = accounts[1];
  let transporter = accounts[2];
  /*let transplantTeamMember = accounts[3];*/


  beforeEach(async () => {
    instance = await OrganTransplantation.new({ from: TransplantSurgeon });
  });
  
  it('should allow the donor surgeon to assign a patient doctor', async () => {
    await instance.assigningtransporter(transporter,{ from: donorsurgeon });
    let isTransporter = await instance.getTransporterTest(transporter);
    assert.isTrue(isTransporter);
    
  });
  it("should allow only the donor surgeon to remove a donated organ", async () => {
    const notDonorSurgeon = accounts[3];
    const organType = 0; // Heart
    const date = Date.now();
    const time = Date.now();

    await instance.RemovingDonatedOrgan(3, organType, date, time, { from: donorsurgeon });
    try {
      await instance.RemovingDonatedOrgan(2, organType, date, time, { from: notDonorSurgeon });
      assert.fail("Expected an exception but none was thrown");
    } catch (error) {
      assert.include(
        error.message,
        "The sender is not eligible to run this function",
        "The error message should contain 'The sender is not eligible to run this function'"
      );
    }
  });
  it("should emit an event after removing a donated organ", async () => {
    const organType = 0; // Heart
    const date = Date.now();
    const time = Date.now();

    const tx = await instance.RemovingDonatedOrgan(1, organType, date, time, { from: donorsurgeon });
    const events = tx.logs.filter((log) => log.event === "DonatedHeartisRemoved"); // Assuming Heart is the organ type being removed
    assert.equal(events.length, 1, "There should be one 'DonatedHeartisRemoved' event emitted");
    assert.equal(events[0].args.DonorSurgeon, donorsurgeon, "The donor surgeon should be set correctly");
    assert.equal(events[0].args.Donor_ID, 1, "The donor ID should be set correctly");
  });
  it("should set the organ state to 'ReadyforDelivery' after removing a donated organ", async () => {
    const organType = 0; // Heart
    const date = Date.now();
    const time = Date.now();

    await instance.RemovingDonatedOrgan(3, organType, date, time, { from: donorsurgeon });
    const organState = await instance.Organstate();
    assert.equal(organState, 1, "The organ state should be set to 'ReadyforDelivery'");
  });

  
});