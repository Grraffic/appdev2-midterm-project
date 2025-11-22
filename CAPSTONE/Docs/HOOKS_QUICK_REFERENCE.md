# Custom Hooks - Quick Reference Card 🎣

## 📋 All Hooks at a Glance

### Authentication Hooks

#### 1️⃣ useLogin
```javascript
const { loading, error, handleGoogleLogin, clearError } = useLogin();
```
- **Purpose:** Google OAuth login
- **Returns:** loading, error, handleGoogleLogin(), clearError()
- **Use in:** LoginPage, any login component

#### 2️⃣ useLoginRedirect
```javascript
useLoginRedirect(user);
```
- **Purpose:** Redirect after login
- **Returns:** { getDefaultRoute }
- **Use in:** LoginPage, after authentication

#### 3️⃣ useLoginForm
```javascript
const { email, password, rememberMe, errors, handleChange, handleSubmit } = 
  useLoginForm(onSubmit);
```
- **Purpose:** Form state & validation
- **Returns:** form data, errors, handlers
- **Use in:** LoginForm, any form component

#### 4️⃣ useRoleSelection
```javascript
const { role, selectRole, getCurrentRoleInfo, getAvailableRoles } = 
  useRoleSelection();
```
- **Purpose:** Role management
- **Returns:** role, role info, available roles
- **Use in:** LoginForm, role selector

---

### Dashboard Hooks

#### 5️⃣ useDashboardData
```javascript
const { stats, recentOrders, notifications, loading, error, refreshData } = 
  useDashboardData();
```
- **Purpose:** Fetch dashboard data
- **Returns:** stats, orders, notifications, loading, error
- **Use in:** StudentDashboard, admin dashboard

#### 6️⃣ useOrderStatus
```javascript
const { getStatusColor, getStatusIcon, getStatusLabel, isActionable, getNextStatus } = 
  useOrderStatus();
```
- **Purpose:** Order status utilities
- **Returns:** status helpers
- **Use in:** Order cards, order list

---

### Product Hooks

#### 7️⃣ useProductCategories
```javascript
const { categories, selectedCategory, selectCategory, getFilteredProducts, hasSubcategories } = 
  useProductCategories();
```
- **Purpose:** Category management
- **Returns:** categories, filtering functions
- **Use in:** ProductCategories, product filter

#### 8️⃣ useProductPagination
```javascript
const { paginatedItems, currentPage, totalPages, nextPage, prevPage, hasNextPage, hasPrevPage } = 
  useProductPagination(items, itemsPerPage);
```
- **Purpose:** Pagination logic
- **Returns:** paginated items, navigation
- **Use in:** ProductCategories, any list

---

## 🚀 Quick Start Examples

### Login Flow
```javascript
import { useLogin, useLoginRedirect } from '../hooks';

function LoginPage() {
  const { user } = useAuth();
  const { loading, error, handleGoogleLogin } = useLogin();
  useLoginRedirect(user);

  return (
    <button onClick={handleGoogleLogin} disabled={loading}>
      {loading ? 'Connecting...' : 'Login'}
    </button>
  );
}
```

### Dashboard
```javascript
import { useDashboardData, useOrderStatus } from '../hooks';

function Dashboard() {
  const { stats, recentOrders } = useDashboardData();
  const { getStatusColor, getStatusIcon } = useOrderStatus();

  return (
    <div>
      <p>Orders: {stats.totalOrders}</p>
      {recentOrders.map(order => (
        <div key={order.id} className={getStatusColor(order.status)}>
          {getStatusIcon(order.status)} {order.item}
        </div>
      ))}
    </div>
  );
}
```

### Products with Pagination
```javascript
import { useProductCategories, useProductPagination } from '../hooks';

function Products() {
  const { categories, selectCategory, getFilteredProducts } = useProductCategories();
  const filtered = getFilteredProducts();
  const { paginatedItems, nextPage, prevPage, hasNextPage } = 
    useProductPagination(filtered, 6);

  return (
    <div>
      {categories.map(cat => (
        <button key={cat.title} onClick={() => selectCategory(cat.title)}>
          {cat.title}
        </button>
      ))}
      {paginatedItems.map(product => (
        <div key={product.id}>{product.title}</div>
      ))}
      <button onClick={prevPage}>Previous</button>
      <button onClick={nextPage} disabled={!hasNextPage()}>Next</button>
    </div>
  );
}
```

### Form with Validation
```javascript
import { useLoginForm } from '../hooks';

function LoginForm() {
  const { email, password, errors, handleChange, handleSubmit } = 
    useLoginForm(async (data) => {
      console.log('Submitting:', data);
    });

  return (
    <form onSubmit={handleSubmit}>
      <input name="email" value={email} onChange={handleChange} />
      {errors.email && <p>{errors.email}</p>}
      
      <input name="password" type="password" value={password} onChange={handleChange} />
      {errors.password && <p>{errors.password}</p>}
      
      <button type="submit">Login</button>
    </form>
  );
}
```

---

## 📊 Hook Comparison

| Hook | Type | State | Side Effects | Reusable |
|------|------|-------|--------------|----------|
| useLogin | Auth | Yes | Yes | ✅ |
| useLoginRedirect | Auth | No | Yes | ✅ |
| useLoginForm | Form | Yes | No | ✅ |
| useRoleSelection | State | Yes | No | ✅ |
| useDashboardData | Data | Yes | Yes | ✅ |
| useOrderStatus | Util | No | No | ✅ |
| useProductCategories | State | Yes | No | ✅ |
| useProductPagination | State | Yes | No | ✅ |

---

## 🔗 Import Patterns

### Recommended: Import from index
```javascript
import { useLogin, useDashboardData } from '../hooks';
```

### Alternative: Import directly
```javascript
import { useLogin } from '../hooks/useLogin';
import { useDashboardData } from '../hooks/useDashboardData';
```

---

## ✅ Common Patterns

### Pattern 1: Data Fetching
```javascript
const { data, loading, error, refresh } = useDataHook();

if (loading) return <Spinner />;
if (error) return <Error message={error} />;
return <Content data={data} />;
```

### Pattern 2: Form Handling
```javascript
const { values, errors, handleChange, handleSubmit } = useFormHook(onSubmit);

return (
  <form onSubmit={handleSubmit}>
    <input name="field" value={values.field} onChange={handleChange} />
    {errors.field && <Error>{errors.field}</Error>}
  </form>
);
```

### Pattern 3: State Management
```javascript
const { state, setState, getState } = useStateHook();

return (
  <div>
    <button onClick={() => setState(newValue)}>Update</button>
    <p>{getState()}</p>
  </div>
);
```

### Pattern 4: Utilities
```javascript
const { getColor, getIcon, getLabel } = useUtilityHook();

return (
  <div className={getColor(status)}>
    {getIcon(status)} {getLabel(status)}
  </div>
);
```

---

## 🧪 Testing Hooks

### Basic Test
```javascript
import { renderHook, act } from '@testing-library/react';
import { useLogin } from '../hooks';

test('useLogin initializes correctly', () => {
  const { result } = renderHook(() => useLogin());
  expect(result.current.loading).toBe(false);
  expect(result.current.error).toBe(null);
});
```

### Test with Actions
```javascript
test('useLogin handles login', async () => {
  const { result } = renderHook(() => useLogin());
  
  act(() => {
    result.current.handleGoogleLogin();
  });
  
  expect(result.current.loading).toBe(true);
});
```

---

## 📚 Documentation

- **Full Guide:** `HOOKS_IMPLEMENTATION_GUIDE.md`
- **Before/After:** `REFACTORING_BEFORE_AFTER.md`
- **Analysis:** `SEPARATION_OF_CONCERNS_ANALYSIS.md`
- **Complete:** `SEPARATION_OF_CONCERNS_COMPLETE.md`

---

## 🎯 Next Steps

1. ✅ Test all hooks in your app
2. ✅ Write unit tests for hooks
3. ✅ Refactor more components
4. ✅ Create service layer
5. ✅ Add more hooks as needed

---

**All hooks are ready to use! Happy coding!** 🚀

