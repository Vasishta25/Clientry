import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { useNavigate } from "react-router-dom"

export default function WelcomePage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <CardTitle className="text-3xl font-bold">Welcome to Clientry</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-center text-gray-600">
            Office Management Software for CAs and their Clients
          </p>
          <div className="flex flex-col gap-3">
            <Button size="lg" className="w-full" onClick={() => navigate("/setup")}>
              Get Started
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}