# =============================================================================
# Deployment Script for La Verdad OrderFlow (PowerShell)
# =============================================================================
# This script helps you deploy both frontend and backend
# Usage: .\deploy.ps1 [frontend|backend|both]
# =============================================================================

# Function to print colored output
function Print-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Print-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Function to check if command exists
function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Check prerequisites
function Test-Prerequisites {
    Print-Info "Checking prerequisites..."
    
    if (-not (Test-CommandExists "git")) {
        Print-Error "Git is not installed. Please install Git first."
        exit 1
    }
    
    if (-not (Test-CommandExists "node")) {
        Print-Error "Node.js is not installed. Please install Node.js first."
        exit 1
    }
    
    if (-not (Test-CommandExists "npm")) {
        Print-Error "npm is not installed. Please install npm first."
        exit 1
    }
    
    Print-Success "All prerequisites are installed"
}

# Deploy backend
function Deploy-Backend {
    Print-Info "Deploying backend to Render..."
    
    # Check if there are uncommitted changes
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Print-Warning "You have uncommitted changes. Committing them now..."
        git add .
        $commitMessage = Read-Host "Enter commit message"
        git commit -m "$commitMessage"
    }
    
    # Push to GitHub (Render will auto-deploy)
    Print-Info "Pushing to GitHub..."
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Backend code pushed to GitHub"
        Print-Info "Render will automatically deploy your backend in 2-5 minutes"
        Print-Info "Check deployment status at: https://dashboard.render.com"
    } else {
        Print-Error "Failed to push to GitHub"
        exit 1
    }
}

# Deploy frontend
function Deploy-Frontend {
    Print-Info "Deploying frontend to Vercel..."
    
    Push-Location frontend
    
    # Build the frontend
    Print-Info "Building frontend..."
    npm run build
    
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Frontend build successful"
    } else {
        Print-Error "Frontend build failed"
        Pop-Location
        exit 1
    }
    
    Pop-Location
    
    # Check if there are uncommitted changes
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Print-Warning "You have uncommitted changes. Committing them now..."
        git add .
        $commitMessage = Read-Host "Enter commit message"
        git commit -m "$commitMessage"
    }
    
    # Push to GitHub (Vercel will auto-deploy)
    Print-Info "Pushing to GitHub..."
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Frontend code pushed to GitHub"
        Print-Info "Vercel will automatically deploy your frontend in 2-3 minutes"
        Print-Info "Check deployment status at: https://vercel.com/dashboard"
    } else {
        Print-Error "Failed to push to GitHub"
        exit 1
    }
}

# Main deployment logic
function Main {
    param([string]$Target)
    
    Write-Host ""
    Write-Host "=========================================="
    Write-Host "  La Verdad OrderFlow Deployment Script"
    Write-Host "=========================================="
    Write-Host ""
    
    Test-Prerequisites
    
    # Get deployment target
    if (-not $Target) {
        Write-Host "What would you like to deploy?"
        Write-Host "1) Frontend only"
        Write-Host "2) Backend only"
        Write-Host "3) Both frontend and backend"
        $choice = Read-Host "Enter your choice (1-3)"
        
        switch ($choice) {
            "1" { Deploy-Frontend }
            "2" { Deploy-Backend }
            "3" { 
                Deploy-Backend
                Write-Host ""
                Deploy-Frontend
            }
            default { 
                Print-Error "Invalid choice"
                exit 1
            }
        }
    } else {
        switch ($Target.ToLower()) {
            "frontend" { Deploy-Frontend }
            "backend" { Deploy-Backend }
            "both" { 
                Deploy-Backend
                Write-Host ""
                Deploy-Frontend
            }
            default { 
                Print-Error "Invalid argument. Use: frontend, backend, or both"
                exit 1
            }
        }
    }
    
    Write-Host ""
    Print-Success "Deployment process completed!"
    Write-Host ""
    Write-Host "📝 Next steps:"
    Write-Host "  1. Check Render dashboard for backend deployment status"
    Write-Host "  2. Check Vercel dashboard for frontend deployment status"
    Write-Host "  3. Test your application at:"
    Write-Host "     Frontend: https://capstone-order-tracking-fe.vercel.app/"
    Write-Host "     Backend:  https://capstone-ordertracking-be.onrender.com"
    Write-Host ""
}

# Run main function
Main $args[0]

