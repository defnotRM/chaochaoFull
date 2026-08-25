const fs = require('fs');
const content = fs.readFileSync('c:/Users/rm/Desktop/CS30everything/year3/1/ise/ChaoChao/chaochao/supabase/migrations/05_seed_data.sql', 'utf8');
const lines = content.split('\n');
lines.forEach((l, i) => {
  if (l.includes('fae663de-d2ab-4e84-8d87-c90ff3914bbf')) {
    console.log(`Line ${i+1}: ${l}`);
  }
});
