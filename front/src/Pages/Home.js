import React from "react";
import doc1 from "../assets/doc1.PNG";
import './Home.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSquare } from '@fortawesome/free-solid-svg-icons';
import { faStethoscope } from '@fortawesome/free-solid-svg-icons';
import { faUserMd } from '@fortawesome/free-solid-svg-icons';
import { faAmbulance } from '@fortawesome/free-solid-svg-icons';
import { faHeart } from '@fortawesome/free-solid-svg-icons';
const Home = ()=>{
    return(
        <header>
            <div className="container">
                <div className="row">
                    <div className="col-md-6 col-lg-6">
                          <h5>We Provide All Health Care Solution</h5>
                          <h2>Protect Your Health And Take care Of Your Health</h2>
                          <button>
                            <a href="#">Read More</a>
                          </button>
                          <span>+</span>
                    </div>
                    <div className="col-lg-6 col-md-6">
                        <div className="header-box">
                        <img src={doc1} alt="doc1"/>
                        
                        
                        <FontAwesomeIcon icon={faUserMd} id="icon2"/>
                        <FontAwesomeIcon icon={faHeart} id="icon3"/>
                        <FontAwesomeIcon icon={faStethoscope} id="icon4"/>
                        
                        </div>
                    </div>
                </div>
            </div>
        </header> 
    )
}
export default Home;
/*<FontAwesomeIcon icon={faAmbulance} id="icon5"/>
<FontAwesomeIcon icon={faSquare} id="icon1"/>*/