import { Fragment } from 'react';
import './App.css';
import Footers from './Components/Footer/Footer';
import Navbars from './Components/Nav/Navbar';
import Home from './Pages/Home'
function App() {
  return ( 
    <Fragment>
      <Navbars />
      <Home/>
      <Footers/>
    </Fragment>
  );
}

export default App;
