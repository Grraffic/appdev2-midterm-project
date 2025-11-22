#!/bin/bash

# =============================================================================
# Deployment Script for La Verdad OrderFlow
# =============================================================================
# This script helps you deploy both frontend and backend
# Usage: ./deploy.sh [frontend|backend|both]
# =============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    if ! command_exists node; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    if ! command_exists npm; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    print_success "All prerequisites are installed"
}

# Deploy backend
deploy_backend() {
    print_info "Deploying backend to Render..."
    
    # Check if there are uncommitted changes
    if [[ -n $(git status -s) ]]; then
        print_warning "You have uncommitted changes. Committing them now..."
        git add .
        read -p "Enter commit message: " commit_message
        git commit -m "$commit_message"
    fi
    
    # Push to GitHub (Render will auto-deploy)
    print_info "Pushing to GitHub..."
    git push origin main
    
    print_success "Backend code pushed to GitHub"
    print_info "Render will automatically deploy your backend in 2-5 minutes"
    print_info "Check deployment status at: https://dashboard.render.com"
}

# Deploy frontend
deploy_frontend() {
    print_info "Deploying frontend to Vercel..."
    
    cd frontend
    
    # Build the frontend
    print_info "Building frontend..."
    npm run build
    
    if [ $? -eq 0 ]; then
        print_success "Frontend build successful"
    else
        print_error "Frontend build failed"
        exit 1
    fi
    
    cd ..
    
    # Check if there are uncommitted changes
    if [[ -n $(git status -s) ]]; then
        print_warning "You have uncommitted changes. Committing them now..."
        git add .
        read -p "Enter commit message: " commit_message
        git commit -m "$commit_message"
    fi
    
    # Push to GitHub (Vercel will auto-deploy)
    print_info "Pushing to GitHub..."
    git push origin main
    
    print_success "Frontend code pushed to GitHub"
    print_info "Vercel will automatically deploy your frontend in 2-3 minutes"
    print_info "Check deployment status at: https://vercel.com/dashboard"
}

# Main deployment logic
main() {
    echo ""
    echo "=========================================="
    echo "  La Verdad OrderFlow Deployment Script"
    echo "=========================================="
    echo ""
    
    check_prerequisites
    
    # Get deployment target
    if [ -z "$1" ]; then
        echo "What would you like to deploy?"
        echo "1) Frontend only"
        echo "2) Backend only"
        echo "3) Both frontend and backend"
        read -p "Enter your choice (1-3): " choice
        
        case $choice in
            1) deploy_frontend ;;
            2) deploy_backend ;;
            3) 
                deploy_backend
                echo ""
                deploy_frontend
                ;;
            *) 
                print_error "Invalid choice"
                exit 1
                ;;
        esac
    else
        case $1 in
            frontend) deploy_frontend ;;
            backend) deploy_backend ;;
            both) 
                deploy_backend
                echo ""
                deploy_frontend
                ;;
            *) 
                print_error "Invalid argument. Use: frontend, backend, or both"
                exit 1
                ;;
        esac
    fi
    
    echo ""
    print_success "Deployment process completed!"
    echo ""
    echo "📝 Next steps:"
    echo "  1. Check Render dashboard for backend deployment status"
    echo "  2. Check Vercel dashboard for frontend deployment status"
    echo "  3. Test your application at:"
    echo "     Frontend: https://capstone-order-tracking-fe.vercel.app/"
    echo "     Backend:  https://capstone-ordertracking-be.onrender.com"
    echo ""
}

# Run main function
main "$@"

