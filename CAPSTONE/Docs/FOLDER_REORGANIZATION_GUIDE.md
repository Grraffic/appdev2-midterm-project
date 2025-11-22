# Frontend Folder Reorganization - Implementation Guide 🚀

## Phase 1: Create New Hook Files

### 1.1 Create `hooks/useAuth.js`
**Purpose:** Extract authentication logic from AuthContext

```javascript
// hooks/useAuth.js
import { useContext } from 'react';
import { AuthContext } from '../context/AuthContext';

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};
```

### 1.2 Create `hooks/useInventory.js`
**Purpose:** Extract inventory logic from InventoryContext

```javascript
// hooks/useInventory.js
import { useContext } from 'react';
import { InventoryContext } from '../context/InventoryContext';

export const useInventory = () => {
  const context = useContext(InventoryContext);
  if (!context) {
    throw new Error('useInventory must be used within InventoryProvider');
  }
  return context;
};
```

### 1.3 Create `hooks/useOrder.js`
**Purpose:** Extract order logic from OrderContext

```javascript
// hooks/useOrder.js
import { useContext } from 'react';
import { OrderContext } from '../context/OrderContext';

export const useOrder = () => {
  const context = useContext(OrderContext);
  if (!context) {
    throw new Error('useOrder must be used within OrderProvider');
  }
  return context;
};
```

### 1.4 Create `hooks/useForm.js`
**Purpose:** Handle form state and validation

```javascript
// hooks/useForm.js
import { useState, useCallback } from 'react';

export const useForm = (initialValues, onSubmit) => {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleChange = useCallback((e) => {
    const { name, value } = e.target;
    setValues(prev => ({ ...prev, [name]: value }));
  }, []);

  const handleBlur = useCallback((e) => {
    const { name } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));
  }, []);

  const handleSubmit = useCallback(async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      await onSubmit(values);
    } finally {
      setIsSubmitting(false);
    }
  }, [values, onSubmit]);

  return {
    values,
    errors,
    touched,
    isSubmitting,
    handleChange,
    handleBlur,
    handleSubmit,
    setValues,
    setErrors,
  };
};
```

### 1.5 Create `hooks/useFetch.js`
**Purpose:** Handle data fetching with loading/error states

```javascript
// hooks/useFetch.js
import { useState, useEffect } from 'react';

export const useFetch = (url, options = {}) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(url, options);
        if (!response.ok) throw new Error('Fetch failed');
        const result = await response.json();
        setData(result);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [url, options]);

  return { data, loading, error };
};
```

### 1.6 Create `hooks/useLocalStorage.js`
**Purpose:** Manage local storage with React state

```javascript
// hooks/useLocalStorage.js
import { useState, useEffect } from 'react';

export const useLocalStorage = (key, initialValue) => {
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(error);
      return initialValue;
    }
  });

  const setValue = (value) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error(error);
    }
  };

  return [storedValue, setValue];
};
```

### 1.7 Create `hooks/index.js`
**Purpose:** Export all hooks from one place

```javascript
// hooks/index.js
export { useAuth } from './useAuth';
export { useInventory } from './useInventory';
export { useOrder } from './useOrder';
export { useForm } from './useForm';
export { useFetch } from './useFetch';
export { useLocalStorage } from './useLocalStorage';
export { useScrollOnState } from './useScrollOnState';
export { useNavigateToSection } from './useNavigateToSection';
```

---

## Phase 2: Reorganize Pages

### 2.1 Create Page Folders
```bash
mkdir -p frontend/src/pages/auth
mkdir -p frontend/src/pages/student
```

### 2.2 Move Files
```bash
# Move auth pages
mv frontend/src/pages/LoginPage.jsx frontend/src/pages/auth/
mv frontend/src/pages/AuthCallback.jsx frontend/src/pages/auth/

# Move student pages
mv frontend/src/pages/ProductCategories.jsx frontend/src/pages/student/
mv frontend/src/pages/StudentDashboard.jsx frontend/src/pages/student/
```

### 2.3 Update Imports in App.jsx
```javascript
// Before
import LoginPage from "./pages/LoginPage";
import AuthCallback from "./pages/AuthCallback";
import ProductCategories from "./pages/ProductCategories";
import StudentDashboard from "./pages/StudentDashboard";

// After
import LoginPage from "./pages/auth/LoginPage";
import AuthCallback from "./pages/auth/AuthCallback";
import ProductCategories from "./pages/student/ProductCategories";
import StudentDashboard from "./pages/student/StudentDashboard";
```

---

## Phase 3: Create Service Layer

### 3.1 Create `services/auth.service.js`
```javascript
// services/auth.service.js
import api from './api';

export const authService = {
  login: (credentials) => api.post('/auth/login', credentials),
  logout: () => api.post('/auth/logout'),
  getProfile: () => api.get('/auth/profile'),
  updateProfile: (data) => api.put('/auth/profile', data),
};
```

### 3.2 Create `services/inventory.service.js`
```javascript
// services/inventory.service.js
import api from './api';

export const inventoryService = {
  getInventory: () => api.get('/inventory'),
  getItem: (id) => api.get(`/inventory/${id}`),
  updateItem: (id, data) => api.put(`/inventory/${id}`, data),
  createItem: (data) => api.post('/inventory', data),
};
```

### 3.3 Create `services/order.service.js`
```javascript
// services/order.service.js
import api from './api';

export const orderService = {
  getOrders: () => api.get('/orders'),
  getOrder: (id) => api.get(`/orders/${id}`),
  createOrder: (data) => api.post('/orders', data),
  updateOrder: (id, data) => api.put(`/orders/${id}`, data),
};
```

---

## Phase 4: Create Constants

### 4.1 Create `constants/roles.js`
```javascript
// constants/roles.js
export const ROLES = {
  STUDENT: 'student',
  ADMIN: 'admin',
};

export const ROLE_NAMES = {
  [ROLES.STUDENT]: 'Student',
  [ROLES.ADMIN]: 'Administrator',
};
```

### 4.2 Create `constants/endpoints.js`
```javascript
// constants/endpoints.js
export const API_ENDPOINTS = {
  AUTH: '/api/auth',
  INVENTORY: '/api/inventory',
  ORDERS: '/api/orders',
  PRODUCTS: '/api/products',
};
```

---

## Phase 5: Update All Imports

### Find and Replace Strategy
1. Use VS Code Find and Replace (Ctrl+H)
2. Replace old paths with new paths
3. Test after each replacement

**Example replacements:**
```
// Old → New
"./pages/LoginPage" → "./pages/auth/LoginPage"
"./pages/AuthCallback" → "./pages/auth/AuthCallback"
"./pages/ProductCategories" → "./pages/student/ProductCategories"
"./pages/StudentDashboard" → "./pages/student/StudentDashboard"
```

---

## ✅ Verification Checklist

- [ ] All hook files created
- [ ] All page folders created
- [ ] All service files created
- [ ] All constant files created
- [ ] All imports updated
- [ ] No broken imports
- [ ] Frontend builds successfully
- [ ] All pages load correctly
- [ ] All components work as expected

---

**Next: Start implementing Phase 1 by creating the hook files!**

