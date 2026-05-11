const User = require('./models/User');
const bcrypt = require('bcryptjs');
const sequelize = require('./config/database');

const seed = async () => {
  try {
    await sequelize.sync();
    const hashedPassword = await bcrypt.hash('admin123', 10);
    const user = await User.findOne({ where: { email: 'admin@example.com' } });
    
    if (!user) {
      await User.create({
        name: 'Administrator',
        email: 'admin@example.com',
        password: hashedPassword,
        role: 'admin',
      });
      console.log('Admin user created: admin@example.com / admin123');
    } else {
      console.log('Admin user already exists');
    }
    process.exit();
  } catch (error) {
    console.error('Seeding failed:', error);
    process.exit(1);
  }
};

seed();
