export default function errorsHandler(err, req, res, next) {
  console.error(err);

  if (res.headersSent) {
    return next(err);
  }

  const isDevelopment = process.env.NODE_ENV === "development";
  const statusCode = err.statusCode || 500;

  res.status(statusCode).json({
    message:
      statusCode === 500 && !isDevelopment
        ? "Internal Server Error"
        : err.message,
    ...(isDevelopment && {
      error: err,
      stack: err.stack,
    }),
  });
}
