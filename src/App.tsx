import { Routes, Route } from 'react-router-dom'
import WelcomePage from './pages/WelcomePage'
import CompanySetup from './pages/CompanySetup'

function App() {
  return (
    <Routes>
      <Route path="/" element={<WelcomePage />} />
      <Route path="/setup" element={<CompanySetup />} />
    </Routes>
  )
}

export default App