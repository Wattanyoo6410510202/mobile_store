function emitReservationSync(req, rows) {
  if (!rows?.length) return;
  try {
    const io = req.app.get('io');
    if (io) io.emit('reservation:sync', { rows });
  } catch (_) {
    /* ignore */
  }
}

module.exports = { emitReservationSync };
