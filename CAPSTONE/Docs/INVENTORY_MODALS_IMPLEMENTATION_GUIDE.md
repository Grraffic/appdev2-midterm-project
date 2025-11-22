# InventoryModals Redesign - Implementation Guide

## Architecture Overview

### Component Hierarchy
```
InventoryModals (Main Component)
├── useInventoryModalForm (Custom Hook)
│   ├── Form State Management
│   ├── Input Change Handling
│   ├── Adjustment Type Toggle
│   ├── Form Validation
│   └── Error Management
├── Header Section
│   ├── Title with Pencil Icon
│   └── Close Button
├── Content Section (2-Column Grid)
│   ├── Left Column (Form)
│   │   ├── Section Title
│   │   ├── Adjustment Type Radio Buttons
│   │   ├── Item Details Form Fields
│   │   └── Inventory Threshold Placeholder
│   └── Right Column (Preview)
│       ├── Item Detail Section
│       │   ├── Image Preview
│       │   └── Item Details Display
│       └── Item Details History
└── Footer Section
    ├── Back Button
    └── Done Button
```

## Custom Hook: useInventoryModalForm

### Purpose
Manages all form logic for the inventory modal, following the separation of concerns pattern.

### State Management
```javascript
// Adjustment type: "Item Details" or "Inventory Threshold"
const [adjustmentType, setAdjustmentType] = useState("Item Details");

// Form data
const [formData, setFormData] = useState({
  name: "",
  educationLevel: "",
  category: "",
  description: "",
  material: "",
  itemType: "",
  stock: 0,
  price: 0,
  image: "/assets/image/card1.png",
});

// Validation errors
const [errors, setErrors] = useState({});
```

### Key Functions

#### handleInputChange(e)
- Updates form data when user types
- Clears validation errors for that field
- Handles numeric conversion for stock and price

#### handleAdjustmentTypeChange(type)
- Updates adjustment type
- Triggers conditional form rendering
- Maintains form data

#### validateForm()
- Validates required fields
- Checks for negative values
- Returns validation status
- Sets error messages

#### handleSubmit(e)
- Prevents default form submission
- Validates form data
- Calls onSubmit callback with form data and adjustment type

## Component Implementation

### Header Section
```jsx
<div className="flex items-center justify-between px-6 py-4 border-b border-gray-200">
  <div className="flex items-center gap-3">
    <Pencil className="text-gray-700" size={20} />
    <h2 className="text-lg font-semibold text-gray-900">
      Add Inventory Item
    </h2>
  </div>
  <button onClick={onClose} className="p-2 rounded-lg hover:bg-gray-100">
    <X size={20} />
  </button>
</div>
```

### 2-Column Grid Layout
```jsx
<div className="grid grid-cols-1 lg:grid-cols-2 gap-0 h-full">
  {/* Left Column */}
  <div className="bg-white p-6 border-r border-gray-200">
    {/* Form Content */}
  </div>
  
  {/* Right Column */}
  <div className="bg-gray-50 p-6 border-l border-gray-200">
    {/* Preview Content */}
  </div>
</div>
```

### Radio Button Implementation
```jsx
<div className="flex gap-4">
  <label className="flex items-center gap-2 cursor-pointer">
    <input
      type="radio"
      name="adjustmentType"
      value="Inventory Threshold"
      checked={adjustmentType === "Inventory Threshold"}
      onChange={() => handleAdjustmentTypeChange("Inventory Threshold")}
      className="w-4 h-4 text-blue-900 border-gray-300 focus:ring-2 focus:ring-blue-500"
    />
    <span className="text-sm text-gray-700">Inventory Threshold</span>
  </label>
  
  <label className="flex items-center gap-2 cursor-pointer">
    <input
      type="radio"
      name="adjustmentType"
      value="Item Details"
      checked={adjustmentType === "Item Details"}
      onChange={() => handleAdjustmentTypeChange("Item Details")}
      className="w-4 h-4 text-blue-900 border-gray-300 focus:ring-2 focus:ring-blue-500"
    />
    <span className="text-sm text-gray-700">Item Details</span>
  </label>
</div>
```

### Conditional Form Rendering
```jsx
{adjustmentType === "Item Details" && (
  <div className="space-y-4">
    {/* Item Details Form Fields */}
  </div>
)}

{adjustmentType === "Inventory Threshold" && (
  <div className="space-y-4">
    {/* Inventory Threshold Fields */}
  </div>
)}
```

### Live Preview Section
```jsx
<div className="bg-white rounded-lg p-4 border border-gray-200">
  {/* Image Preview */}
  {formData.image ? (
    <img src={formData.image} alt="Item preview" className="..." />
  ) : (
    <div className="...">No image selected</div>
  )}
  
  {/* Item Details */}
  <div className="space-y-3 text-sm">
    <div>
      <p className="text-gray-600 font-medium">Item Category</p>
      <p className="text-gray-900">{formData.category || "—"}</p>
    </div>
    {/* More details */}
  </div>
</div>
```

## Form Fields

### Item Details Form
- **Item Name** (required)
- **Education Level** (required)
- **Category** (required)
- **Description/Size** (optional)
- **Material/Type** (optional)
- **Item Type** (required)
- **Stock Quantity** (required)
- **Price** (required)
- **Image URL** (optional)

### Inventory Threshold Form
- Placeholder for future implementation
- Can add threshold-specific fields

## Styling

### Color Scheme
- **Primary:** Dark Blue (#0C2340)
- **Secondary:** Orange (#e68b00)
- **Backgrounds:** White (#ffffff), Gray (#f3f4f6)
- **Borders:** Light Gray (#d1d5db)
- **Text:** Dark Gray (#374151)

### Layout Classes
- **Grid:** `grid grid-cols-1 lg:grid-cols-2`
- **Spacing:** `p-6`, `gap-4`, `space-y-4`
- **Borders:** `border-r border-gray-200`, `border-l border-gray-200`
- **Responsive:** Stacks on mobile, 2-column on desktop

## Validation

### Required Fields
- Item Name
- Education Level
- Category
- Item Type
- Stock Quantity
- Price

### Validation Rules
- Stock cannot be negative
- Price cannot be negative
- All required fields must be filled

### Error Display
```jsx
{errors.fieldName && (
  <p className="text-red-500 text-xs mt-1">
    {errors.fieldName}
  </p>
)}
```

## Integration Points

### Props
```javascript
{
  modalState: { isOpen, mode },      // Modal state
  selectedItem: Object,               // Item being edited
  onClose: Function,                  // Close handler
  onAdd: Function,                    // Add handler
  onUpdate: Function,                 // Update handler
  onDelete: Function,                 // Delete handler
}
```

### Hook Usage
```javascript
const {
  formData,
  errors,
  adjustmentType,
  handleInputChange,
  handleAdjustmentTypeChange,
  handleSubmit,
  validateForm,
} = useInventoryModalForm(selectedItem, onSubmit, onClose);
```

## Future Enhancements

1. **Inventory Threshold Fields**
   - Minimum stock level
   - Maximum stock level
   - Reorder quantity
   - Alert settings

2. **Advanced Features**
   - Image upload with drag-and-drop
   - Batch operations
   - Item templates
   - History tracking

3. **Improvements**
   - Add loading states
   - Add success/error notifications
   - Add keyboard shortcuts
   - Add auto-save functionality

## Testing Checklist

- [ ] Modal opens correctly
- [ ] 2-column layout displays
- [ ] Radio buttons work
- [ ] Form fields update preview
- [ ] Validation works
- [ ] Form submission works
- [ ] Responsive on mobile
- [ ] Responsive on tablet
- [ ] Responsive on desktop
- [ ] All fields accept input
- [ ] Error messages display
- [ ] Image preview updates

---

**Status:** ✅ Implementation Complete
**Last Updated:** 2025-10-28

