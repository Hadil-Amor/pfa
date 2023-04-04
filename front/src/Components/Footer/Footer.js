import React from "react";
import footerlog from '../../assets/logo.png';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPhone } from '@fortawesome/free-solid-svg-icons';
const Footers = () => {
    return (
      <footer>
        <div className="container">
          <div className="row">
            <div className="col-md-3 col-sm-6">
              <img src={footerlog} alt="footerlog" />
              <p>
                Lorem ipsum is dolor sit amet, csectetur adipiscing elit, dolore
                smod tempor incididunt ut labore et.
              </p>
              <div className="footer-contact">
                <div className="footer-icon">
                  <FontAwesomeIcon icon={faPhone} />
                </div>
                <div className="footer-text">
                  <h6>Contact Us</h6>
                  <h4>(+216)55555555</h4>
                </div>
              </div>
            </div>
  
            <div className="col-md-3 col-sm-6">
              <h2>Quick link</h2>
              <ul>
                <li>
                  <a href="#">Home</a>
                </li>
                <li>
                  <a href="#">About us</a>
                </li>
                <li>
                  <a href="#">Our Team</a>
                </li>
                <li>
                  <a href="#">Last News</a>
                </li>
              </ul>
            </div>
  
            <div className="col-md-3 col-sm-6">
              <h2>Our services</h2>
              <ul>
                <li>
                  <a href="#">Precis Diagnosis </a>
                </li>
                <li>
                  <a href="#">Medical Analyses</a>
                </li>
                <li>
                  <a href="#">Treatments </a>
                </li>
                <li>
                  <a href="#">Medecines search </a>
                </li>
                <li>
                  <a href="#">Organ Donation & Tranplantation</a>
                </li>
              </ul>
            </div>
  
            <div className="col-md-3 col-sm-6">
              <h2>Subscribe as a patient</h2>
              <form>
                <input type="text" />
                <button type="submit">Subscribe Now</button>
              </form>
            </div>
          </div>
        </div>
        <div className="footer-buttom">
          <div className="container">
            <div className="row">
              <div className="col-lg-12 col-md-12">
                <span>Copyright © 2023 Design & Developed by Roua_Walha</span>
              </div>
            </div>
          </div>
        </div>
      </footer>
    );
  };



export default Footers;