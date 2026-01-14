#!/bin/bash

# Script para corregir menu_page.dart reemplazando datos mock con MockData

FILE="/Users/acastillolic/VisualCode/Clients/Energy/energy-coffee/lib/features/menu/pages/menu_page.dart"

# Crear backup
cp "$FILE" "${FILE}.backup"

# Usar sed para hacer los reemplazos necesarios
# 1. Reemplazar .title por .name en CustomizationGroup
sed -i '' 's/title: '\''Temperatura'\''/name: '\''Temperatura'\''/g' "$FILE"
sed -i '' 's/title: '\''Tamaño'\''/name: '\''Tamaño'\''/g' "$FILE"
sed -i '' 's/title: '\''Tipo de Leche'\''/name: '\''Tipo de Leche'\''/g' "$FILE"
sed -i '' 's/title: '\''Shots'\''/name: '\''Shots'\''/g' "$FILE"
sed -i '' 's/title: '\''Shots de Espresso'\''/name: '\''Shots de Espresso'\''/g' "$FILE"
sed -i '' 's/title: '\''Toppings'\''/name: '\''Toppings'\''/g' "$FILE"
sed -i '' 's/title: '\''Extras'\''/name: '\''Extras'\''/g' "$FILE"
sed -i '' 's/title: '\''Endulzantes'\''/name: '\''Endulzantes'\''/g' "$FILE"
sed -i '' 's/title: '\''Sabores'\''/name: '\''Sabores'\''/g' "$FILE"
sed -i '' 's/title: '\''Untables'\''/name: '\''Untables'\''/g' "$FILE"

# 2. Reemplazar extraPrice por priceModifier
sed -i '' 's/extraPrice:/priceModifier:/g' "$FILE"

# 3. Reemplazar category por categoryId
sed -i '' "s/category: 'coffee'/categoryId: 'coffee'/g" "$FILE"
sed -i '' "s/category: 'drinks'/categoryId: 'drinks'/g" "$FILE"
sed -i '' "s/category: 'food'/categoryId: 'food'/g" "$FILE"

echo "✅ Reemplazos básicos completados en menu_page.dart"
echo "⚠️  Nota: Aún quedan errores de campos faltantes (createdAt, updatedAt, etc.)"
echo "📝 Recomendación: Reemplazar toda la sección de datos mock con MockData manualmente"
