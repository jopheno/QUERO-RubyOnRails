# Todo list for [QUERO-RubyOnRails](https://github.com/reyhammer/QUERO-RubyOnRails)

### Access
- [ ] Only admins can list all the admissions.
- [ ] School managers should only see a list of admissions that are currently pending.
- [ ] Only the bank or a third party system, school managers and admins can set bills to paid status.

### Features:
- [ ] Create a controller for payments.
- [ ] Auto update next bill status to "To expire".
- [ ] Once all the bills are successfully paid, the billing status must change to "Complete" automatically.
- [ ] Course cost must be declared and managed in a more interactive way, and not a const value.
- [ ] Add payment method to Billing data structure or add possibility to change payment method from bills

### Exceptions:
- [ ] Catch exceptions when more than one payment is made to a unique bill.

### Bad Practices:
- [ ] There is no need to have year and month columns at Bills table, once they are already included into DateTime due_date column.

### Security:
- [ ] Configuration of Rack-Cors
