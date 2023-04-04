import React from "react";
import {Navbar, Container,NavDropdown,Nav} from 'react-bootstrap';
import './Nav.css';
import logo from '../../assets/logo.png';
import phone from '../../assets/phone.png';

const Navbars = () =>{
    return(
        <Navbar bg="light" expand="lg">
      <Container>
      <Navbar.Brand >
            <img src={logo} title="logo" id="logo"/>
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
            <Nav.Link className="active">Home</Nav.Link>
            <NavDropdown title="Pages" id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">About us</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">Our Team</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">FAQ</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">Booking</NavDropdown.Item>
            </NavDropdown>
            <NavDropdown title="Diagnostic " id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">Doctor</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">Patient</NavDropdown.Item> 
              
              
            </NavDropdown>
            <NavDropdown title="Medical analysis " id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">Doctor</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">Laboratery</NavDropdown.Item>
              
            </NavDropdown>
            <NavDropdown title="Medecines " id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">Doctor</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">Pharmacy</NavDropdown.Item>
              
            </NavDropdown>
            <NavDropdown title="Donation " id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">Doctor</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.1">Transplant team member</NavDropdown.Item>
              
            </NavDropdown>

            <Navbar.Brand >
            <img src={phone} title="phone"/>
        </Navbar.Brand>
            <Nav.Link >
                (+216) 55555555</Nav.Link>
            <Nav.Link >
                <button>
                 Contact us <span> {'>'} </span></button>
            </Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>

    )
}




export default Navbars;