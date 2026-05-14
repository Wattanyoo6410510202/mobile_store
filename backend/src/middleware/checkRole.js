module.exports = (requiredRole) => {
  return (req, res, next) => {
    console.log('User in checkRole:', req.user);
    if (!req.user || req.user.role !== requiredRole) {
      console.log('Access Denied: Required', requiredRole, 'but got', req.user ? req.user.role : 'none');
      return res.status(403).json({ message: 'ไม่มีสิทธิ์เข้าถึงส่วนนี้ (Access Denied)' });
    }
    next();
  };
};
